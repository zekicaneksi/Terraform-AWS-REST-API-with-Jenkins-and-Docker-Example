#! /bin/bash
# Update system
sudo apt-get update && sudo apt-get -y upgrade

# Install Docker Engine
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker

# Install Git
sudo apt install -y git

# Clone the GitHub repository
sudo mkdir -p /var/www/app
sudo git clone https://${GIT_USERNAME}:${GIT_PAT}@github.com${GIT_ADDRESS}.git /var/www/app

# Create backend's Docker image
cd /var/www/app/app/backend
sudo docker build \
-t backend \
--build-arg GIT_USERNAME=${GIT_USERNAME} \
--build-arg GIT_PAT=${GIT_PAT} \
.
# Create frontend's Docker image
cd /var/www/app/app/frontend
sudo docker build \
-t frontend \
--build-arg GIT_USERNAME=${GIT_USERNAME} \
--build-arg GIT_PAT=${GIT_PAT} \
.

# Create Jenkins' Docker image
cd /var/www/app/jenkins
sudo docker build -t jenkins .

# Run backend container
sudo docker run -d --name backend -p ${BACKEND_PORT}:3000 \
--env FRONTEND_ADDRESS="$([ ${IS_FRONTEND_SECURE} == true ] && echo "https" || echo "http")://${SERVER_IP_ADDRESS}:${FRONTEND_PORT}" \
backend

# Run frontend container
sudo docker run -d --name frontend -p ${FRONTEND_PORT}:3000 \
--env NEXT_PUBLIC_BACKEND_ADDRESS="$([ ${IS_BACKEND_SECURE} == true ] && echo "https" || echo "http")://${SERVER_IP_ADDRESS}:${BACKEND_PORT}" \
frontend

# Run Jenkins' container
sudo docker run -d --name jenkins -p ${JENKINS_GUI_PORT}:8080 -p ${JENKINS_SSH_PORT}:50000 --restart=on-failure \
--env GITHUB_USERNAME=${GIT_USERNAME} \
--env GITHUB_PAT=${GIT_PAT} \
--env GITHUB_ADDRESS=${GIT_ADDRESS} \
--env USER_ID=${JENKINS_USER_ID} \
--env USER_PW=${JENKINS_USER_PW} \
--env SERVER_IP_ADDRESS=${SERVER_IP_ADDRESS} \
--env BACKEND_PORT=${BACKEND_PORT} \
--env IS_BACKEND_SECURE=${IS_BACKEND_SECURE} \
--env FRONTEND_PORT=${FRONTEND_PORT} \
--env IS_FRONTEND_SECURE=${IS_FRONTEND_SECURE} \
--env KEY_PAIR_CONTENT="${KEY_PAIR_CONTENT}" \
jenkins

FROM node:lts-alpine

ARG GIT_USERNAME
ARG GIT_PAT

# Create app directory
WORKDIR /app

# Install dependencies required to git clone.
RUN apk update && \
    apk add --update git && \
    apk add --update openssh

RUN git clone https://${GIT_USERNAME}:${GIT_PAT}@github.com/zekicaneksi/Terraform-AWS-REST-API-with-Jenkins-and-Docker-Example.git /app

WORKDIR /app/app/frontend

RUN npm install

EXPOSE 3000

CMD [ "yarn", "dev"]
FROM jenkins/jenkins:lts-jdk11

USER root
RUN apt-get update && apt-get install -y git
USER jenkins

ENV CASC_JENKINS_CONFIG=/var/jenkins_home/ConfigurationAsCode.yaml
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

COPY ./ConfigurationAsCode.yaml /var/jenkins_home
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
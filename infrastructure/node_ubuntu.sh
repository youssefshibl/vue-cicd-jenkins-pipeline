#!/bin/bash

# Install necessary dependencies
apt-get update
apt-get install -y sudo 
sudo apt-get install -y \
    openjdk-11-jdk \
    git \
    curl \
    openssh-server \
    openssh-client

# Install Docker (optional, if needed for Jenkins pipeline)
#sudo apt-get install -y docker.io

# Install any other dependencies required by your build environment

# Install Jenkins agent JAR
AGENT_WORKDIR="/var/jenkins_agent"
sudo mkdir -p $AGENT_WORKDIR
sudo curl --create-dirs -sSLo /usr/share/jenkins/agent.jar \
    https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/4.11/remoting-4.11.jar
sudo chmod 755 /usr/share/jenkins

SSH_USERNAME=jenkins
SSH_PASSWORD=jenkins

useradd -m -d "/home/$SSH_USERNAME" -s /bin/bash "$SSH_USERNAME" && \
    echo "$SSH_USERNAME:$SSH_PASSWORD" | chpasswd


echo "Dependencies installation completed."
#!/bin/bash

# Check if the script is run with superuser privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Update the package index
sudo apt update

# Install Git
sudo apt install git -y

# Install OpenJDK 17
sudo apt install openjdk-17-jdk openjdk-17-jre -y

# Set JAVA_HOME and update PATH in ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> /home/$SUDO_USER/.bashrc
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /home/$SUDO_USER/.bashrc
# Source the updated .bashrc for the current session
source /home/$SUDO_USER/.bashrc

# Install Maven
sudo apt install maven -y

# Add Jenkins repository and install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt update
sudo apt install jenkins -y

# Install required packages for Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker's official GPG key and repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y

# Install Ngrok
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update
sudo apt install ngrok -y

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl  # Clean up the downloaded kubectl

# Add Ansible PPA and install Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y

# Set the LANG variable in /etc/default/locale
if grep -q "^LANG=" /etc/default/locale; then
    sed -i 's/^LANG=.*/LANG="en_IN.UTF-8"/' /etc/default/locale
else
    echo 'LANG="en_IN.UTF-8"' >> /etc/default/locale
fi

# Inform the user to log out and back in for locale changes to take effect
echo "Installation completed. Please log out and back in for the changes to take effect."
hfgyhfhghfghfg

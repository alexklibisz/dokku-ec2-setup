#!/bin/bash
set -e

# Public IP of the EC2 instance
ip="$1"

# Install Dokku on the EC2 instance
ssh ubuntu@$ip wget https://raw.githubusercontent.com/dokku/dokku/v0.5.2/bootstrap.sh
ssh ubuntu@$ip sudo DOKKU_TAG=v0.5.2 bash bootstrap.sh
ssh ubuntu@$ip rm bootstrap.sh*

# Open the ip address to complete web setup and wait for user
xdg-open http://"$ip"
read -p "Complete the web setup, then press any key to continue. " -n1 -s

# Configure the public key for the dokku user on the EC2 Instance
cat ~/.ssh/id_rsa.pub | ssh ubuntu@$ip "sudo sshcommand acl-add dokku ${USER}"


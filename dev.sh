#!/bin/bash

sudo yum update -y && yum install -y git unzip wget curl jq

sudo yum  amazon-linux-extras install java-openjdk11

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
sudo systemctl status amazon-ssm-agent

sudo yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl status amazon-cloudwatch-agent

wget https://inspector-agent.amazonaws.com/linux/latest/install
chmod +x install

sudo yum install -y docker 
sudo systemctl start docker
sudo systemctl enable docker


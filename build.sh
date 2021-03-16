#!/bin/bash
set -ex
sudo apt-get update
sudo apt-get install docker -y
sudo apt-get install docker-compose -y
export DOCKER_USERNAME="rajanaidu356"
export DOCKER_PASSWORD="R@jand356"
mkdir raja
cd raja
git clone https://github.com/rajand87/TechChallengeApp.git
cd TechChallengeApp
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"


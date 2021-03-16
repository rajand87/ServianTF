#!/bin/bash
set -ex
sudo apt-get update
sudo apt-get install docker -y
sudo apt-get install docker-compose -y
docker run -p 80:3000 rajanaidu356/gotodolist:latest serve
#!/bin/bash
# server-cmds.sh

export BACKEND_IMAGE=$1
export FRONTEND_IMAGE=$2
export MYSQL_IMAGE=$3
export DOCKER_USER=$4
export DOCKER_PWD=$5

echo "Logging into Docker Hub..."
echo $DOCKER_PWD | docker login -u $DOCKER_USER --password-stdin

# echo "Pulling images..."
# docker pull $BACKEND_IMAGE
# docker pull $FRONTEND_IMAGE
# docker pull $MYSQL_IMAGE

echo "Starting services using docker-compose..."
docker-compose -f docker-compose.yml up -d --remove-orphans

echo "Deployment success!"


# export IMAGE=$1
# export DOCKER_USER=$2
# export DOCKER_PWD=$3
# echo $DOCKER_PWD | docker login -u $DOCKER_USER --password-stdin
# docker-compose -f docker-compose.yml up --detach
# echo "success"

#!/bin/bash
set -e
HOST_NAME=${HOST_NAME:-127.0.0.1}
GERRIT_NAME=${GERRIT_NAME:-gerrit}
JENKINS_NAME=${JENKINS_NAME:-jenkins}
REDMINE_NAME=${REDMINE_NAME:-redmine}
NEXUS_NAME=${NEXUS_NAME:-nexus}

NGINX_IMAGE_NAME=${NGINX_IMAGE_NAME:-nginx}
NGINX_NAME=${NGINX_NAME:-nginx-proxy}

GERRIT_HOST=$(docker inspect -f '{{.Node.IP}}' ${GERRIT_NAME})
JENKINS_HOST=$(docker inspect -f '{{.Node.IP}}' ${JENKINS_NAME})
REDMINE_HOST=$(docker inspect -f '{{.Node.IP}}' ${REDMINE_NAME})

# Start proxy
if [ ${#NEXUS_WEBURL} -eq 0 ]; then #proxy nexus
    docker run \
    --name ${NGINX_NAME} \
    -p 80:80 \
    -d ${NGINX_IMAGE_NAME}
else #without nexus
    docker run \
    --name ${NGINX_NAME} \
    -p 80:80 \
    -e constraint:net==public \
    -e SERVER_NAME=${HOST_NAME} \
    -e GERRIT_URI=${GERRIT_NAME} \
    -e GERRIT_HOST=${GERRIT_HOST} \
    -e JENKINS_URI=${JENKINS_NAME} \
    -e JENKINS_HOST=${JENKINS_HOST} \
    -e REDMINE_URI=${REDMINE_NAME} \
    -e REDMINE_HOST=${REDMINE_HOST} \
    -d ${NGINX_IMAGE_NAME}
fi

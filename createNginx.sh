#!/bin/bash -x
set -e
GERRIT_NAME=${GERRIT_NAME:-gerrit}
JENKINS_NAME=${JENKINS_NAME:-jenkins}
REDMINE_NAME=${REDMINE_NAME:-redmine}
NEXUS_NAME=${NEXUS_NAME:-nexus}

NGINX_IMAGE_NAME=${NGINX_IMAGE_NAME:-nginx}
NGINX_NAME=${NGINX_NAME:-proxy}
NGINX_MAX_UPLOAD_SIZE=${NGINX_MAX_UPLOAD_SIZE:-200m}

NGINX_USE_HTTPS=${NGINX_USE_HTTPS:-1}

if [ ${NGINX_USE_HTTPS} -eq 1 ]; then
    if [ ! -e ~/nginx-docker/cert.key ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout cert.key -out cert.crt
    fi
fi

PROXY_CONF=proxy.conf

# Setup proxy URI

~/nginx-docker/proxyconf.sh > ~/nginx-docker/${PROXY_CONF}

args=( run \
      --name ${NGINX_NAME} \
      --link ${GERRIT_NAME}:${GERRIT_NAME} \
      --link ${JENKINS_NAME}:${JENKINS_NAME} \
      --link ${REDMINE_NAME}:${REDMINE_NAME} )

if [ ${#NEXUS_WEBURL} -eq 0 ]; then
    args+=( --link ${NEXUS_NAME}:${NEXUS_NAME} \
            -v ~/nginx-docker/directory.nexus.html:/usr/share/nginx/html/directory.html:ro )
else
    args+=( -v ~/nginx-docker/directory.html:/usr/share/nginx/html/directory.html:ro )
fi

if [ ${NGINX_USE_HTTPS} -eq 1 ]; then
    args+=( -v ~/nginx-docker/cert.crt:/etc/nginx/cert.crt:ro \
            -v ~/nginx-docker/cert.key:/etc/nginx/cert.key:ro \
            -p 443:443 )
fi

args+=( -p 80:80 \
        -v ~/nginx-docker/${PROXY_CONF}:/etc/nginx/conf.d/default.conf:ro )
args+=( -d ${NGINX_IMAGE_NAME} )

docker ${args[@]}


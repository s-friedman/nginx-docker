#!/bin/bash
set -e
PROXY_CONF=/etc/nginx/conf.d/default.conf

sed -i "s/{SERVER_NAME}/${SERVER_NAME}/g" ${PROXY_CONF}
sed -i "s/{GERRIT_URI}/${GERRIT_URI}/g" ${PROXY_CONF}
sed -i "s/{GERRIT_HOST}/${GERRIT_HOST}/g" ${PROXY_CONF}
sed -i "s/{JENKINS_URI}/${JENKINS_URI}/g" ${PROXY_CONF}
sed -i "s/{JENKINS_HOST}/${JENKINS_HOST}/g" ${PROXY_CONF}
sed -i "s/{REDMINE_URI}/${REDMINE_URI}/g" ${PROXY_CONF}
sed -i "s/{REDMINE_HOST}/${REDMINE_HOST}/g" ${PROXY_CONF}
#sed -i "s/{NEXUS_URI}/${NEXUS_URI}/g" ${PROXY_CONF}

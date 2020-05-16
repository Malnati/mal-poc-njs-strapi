#!/usr/bin/env bash
set -e

if [[ -z "${SLEEP_TIME}" ]]; then
    SLEEP_TIME=0
fi
sleep ${SLEEP_TIME}
java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /var/lib/strapi/strapi.jar
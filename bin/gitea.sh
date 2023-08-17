#!/bin/bash

#
# A simple script that uses docker-compose to provision
#
# - postgres
# - gitea
#


set -e

export GITEA_VERSION=${GITEA_VERSION:-1.17.2}
# Host port where Gitea will serve its web/API.
export GITEA_WEB_PORT=${GITEA_WEB_PORT:-8080}
# Host port where Gitea will serve ssh.
export GITEA_SSH_PORT=${GITEA_SSH_PORT:-2222}
export GITEA_ADMIN_USERNAME=${GITEA_ADMIN_USERNAME:-gitea}
export GITEA_ADMIN_PASSWORD=${GITEA_ADMIN_PASSWORD:-password}

# The HOME directory for the git user. This directory will contain the
# .gitconfig and possible .gnupg directories that Gitea's git calls will use.
export GITEA_HOME_PATH=/data/git

# Host port where Postgres will serve.
export POSTGRES_PORT=${POSTGRES_PORT:-5432}

here=$(dirname ${0})
DOCKER_COMPOSE_FILE=${DOCKER_COMPOSE_FILE:-${here}/../etc/infra/docker-compose.yaml}

function log {
    cmd=$(basename ${0})
    echo "[${cmd}] ${1}"
}

function die() {
    log "error: ${1}"
    exit 1
}

function up() {
    docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --force-recreate
}

function stop() {
    log "stopping ..."
    docker-compose -f ${DOCKER_COMPOSE_FILE} stop
}

function logs() {
    docker-compose -f ${DOCKER_COMPOSE_FILE} logs -f
}

function down() {
    log "down ..."
    docker-compose -f ${DOCKER_COMPOSE_FILE} down
    log "pruning volumes ..."
    docker system prune -f --volumes
}


if [ "${1}" = "up" ]; then
    up
    echo "****************************************************"
    echo "run these commands to target the right environemnt:"
    echo
    echo "export COMPOSE_FILE=${PWD}/docker-compose-infra.yaml"
elif [ "${1}" = "logs" ]; then
    logs
elif [ "${1}" = "stop" ]; then
    stop
elif [ "${1}" = "down" ]; then
    down
else
    die "expected either 'up', 'logs', 'stop', 'down'"
fi

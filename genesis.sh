#!/bin/bash

function main() {
if [[ -z $DEF_NETWORK ]]
then
    DEF_NETWORK=fornax-genesis
fi

# FIXME colocar linha devolta
#check couchdb && couch_crash
check portainer_agent && portaineragent_up
check portainer && portainer_up
check etcd && etcd_up

# TODO
# Criar materiais
# Subir CA
# Subir Orderer
# Subir Peers
# O primeiro Peer:
## Cria genesis
## Doca
# Os outros peers:
## Doca

# Subir Composer Playground como servico
# Servico de Composer CARD ADMIN
# Composer REST upload


## TODO Watchdog
# Fazer scaleup:
# etcd
# couchdb

clean
};

function clean() {
    docker system prune -f
    docker volume prune -f
};
function couch_crash() {
    log ERROR docker service couchdb notfound
    exit 1
};
function etcd_up() {
    ## https://github.com/lfkeitel/docker-etcd
    log INFO up etcd
    docker service create \
      --name etcd \
      --network $DEF_NETWORK \
      -d \
      -e 'CLUSTER_SIZE=3' \
      --constraint 'node.role == manager' \
      --replicas=3 \
      lfkeitel/etcd:latest
};
function portainer_up() {
    log INFO up portainer
    docker service create \
        --name portainer \
        --network $DEF_NETWORK \
        -d \
        --publish 9000:9000 \
        --constraint 'node.role == manager' \
        --replicas=1 \
        portainer/portainer -H "tcp://tasks.portainer_agent:9001" --tlsskipverify
};
function portaineragent_up() {
    log INFO up portainer agent
    docker service create \
        --name portainer_agent \
        --network $DEF_NETWORK \
        -d \
        -e AGENT_CLUSTER_ADDR=tasks.portainer_agent \
        --mode global \
        --constraint 'node.platform.os == linux' \
        --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
        portainer/agent
};

function check() {
## TODO scale up
#SIZE=1
#if [[ ! -z "$2" ]]
#then
#    SIZE=$2
#fi
#
#docker service ls --filter="name=$1" --format "{{index (split .Replicas \"/\") 0}}"
#STATUS=$(docker service ls --filter="name=$1" --format "{{index (split .Replicas \"/\") 0}}")
#if [[ -z "$STATUS" ]]
#then
#    STATUS=0
#fi
#
#echo "name: $1"
#echo "Size: $SIZE"
#echo "STATUS: $STATUS"
#
#if [[ $STATUS -ge $SIZE ]]
#then
#    return 1
#else
#    return 0
#fi
    if docker service inspect $1 2>&1 > /dev/null; then
        return 1
    else
        return 0
    fi
};
function log() {
#    echo "$(date +"%s %FT%T") [$(hostname -A)|$(hostname -I)] $@"
# FIXME colocar somente linha abaixo
    echo "$(date +"%s %FT%T") [$(hostname)] $@"
};
function noop() {
    log INFO Esperando...
    sleep 10
};

while true;
do
    main
    ## FIXME colocar noop pra cima
    noop
done

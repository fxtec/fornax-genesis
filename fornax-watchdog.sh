#!/bin/bash
mkdir -p /etc/fornax

function log() {
    echo "$(date +"%s %FT%T") [$(hostname -A)|$(hostname -I)] $@"
};
function noop() {
    log INFO Esperando...
    sleep 10
};

while true;
do
    et fornax-genesis.sh > /dev/null
    if [[ "$?" == "0" ]]
    then
        cd /etc/fornax
        etoutput fornax-genesis.sh > /dev/null
        chmod 700 fornax-genesis.sh
    else
        log ERROR docker service etcd notfound
    fi
    cd /etc/hyperledger/fabric/
    /etc/fornax/fornax-genesis.sh
    noop
done

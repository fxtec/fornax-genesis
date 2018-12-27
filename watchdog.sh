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
    cd /etc/fornax
    et fornax-genesis.sh
    if [[ "$?" == "0" ]]
    then
        etoutput fornax-genesis.sh
        chmod 700 fornax-genesis.sh
        cd /etc/hyperledger/fabric/
        /etc/fornax/fornax-genesis.sh
    fi
    ## FIXME colocar noop pra  cima
    noop
done

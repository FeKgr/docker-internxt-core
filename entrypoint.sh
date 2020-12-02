#!/bin/bash

# == Run
#
echo "===> START"
NVM_BIN=/root/.nvm/versions/node/v8.15.1/bin
SHLVL=1
PATH=/root/.nvm/versions/node/v8.15.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
NVM_INC=/root/.nvm/versions/node/v8.15.1/include/nod

echo "---> Check if Config exists"
if [[ ! -f /root/.xcore/configs/nodeconfig.json ]]; then
    if [ -z ${INXT_ADDRESS+x} ] || [ -z ${STORAGE_PATH+x} ] || [ -z ${STORAGE_SIZE+x} ] || [ -z ${RPC_PORT+x} ] || [ -z ${RPC_ADDRESS+x} ] ; then
        echo "Config does not exist, no ENV Vars Provided, cannot start node"
        echo "Required Vars:"
        echo "INXT_ADDRESS, eg. 0x0000000000000000000000000000000000000000"
        echo "STORAGE_PATH, eg /home/user/xcore"
        echo "STORAGE_SIZE, eg. 10TB"
        echo "RPC_PORT, eg. 12345"
        echo "RPC_ADDRESS, eg. 81.81.81.81"
        exit
    else
        echo "Config does not exist, creating with provided ENV Vars"
        mkdir /root/.xcore/logs
        xcore create --inxt ${INXT_ADDRESS} --storage ${STORAGE_PATH} --size ${STORAGE_SIZE} --rpcport ${RPC_PORT} --rpcaddress ${RPC_ADDRESS} --logdir /root/.xcore/logs/xcore.log --outfile /root/.xcore/configs/nodeconfig.json --noedit
    fi

else
    echo "Config exists, ignore defined ENV Vars and use existing config,starting node"
fi

set -x
export STORJ_NETWORK=INXT
xcore daemon
xcore start --config /root/.xcore/configs/nodeconfig.json

while sleep 60; do
    ps aux |grep xcore-daemon |grep -q -v grep
    DAEMON_STATUS=$?
    if [ $DAEMON_STATUS -ne 0 ]; then
        echo "Daemon has exited."
        exit 1
    fi
done

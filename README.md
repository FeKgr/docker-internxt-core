# Dockerfile for Internxt-core
With this Dockerfile you can Build your own Image for Docker. It is based on https://github.com/internxt/core-daemon

## Build Dockerimage
```
docker build internxt -t internxt-core
```

## Usage
During the  Startup of the Dockercontainer, it checks if an internxt config file is already existing. If not, it will generate one, based on the provided Env Variables.

### Variables
Variables only needs to be provided if no internxt Config file exists (eg. for new nodes)
Variable | Example |Description
-------------|-------------|-------------
INXT_ADDRESS | 0x0000000000000000000000000000000000000000 | Wallet Address for Payments
STORAGE_PATH | /home/user/xcore | Path of folder to Share
STORAGE_SIZE | 10GB | Size of Storage to Share
RPC_PORT | 12345 | Public Port of Internxt Node
RPC_ADDRESS | 81.81.81.81 | Public IP Address of Internxt Node

### Volumes
Following Volumes should be mounted to ensure Data persistency if the Container gets deleted or replaced
Container Directory | Description
------------- |-------------
/root/.xcore | Contains XCore Logs and Config
STORAGE_PATH | Path to XCore Data, defined per ENV Var

### Configfile & Data
If you already have an Configfile (eg. migration an node) it needs to be placed on the  Volumemount of /root/.xcore in a foldere called configs. The Name of the Configfile needs to be nodeconfig.json

Also you need to rsync the existing Nodedata to your specified STORAGE_PATH, respectivley the defined Mountpoint of it.

### Startup
```
docker run -d --name internxt --env INXT_ADDRESS=0x0000000000000000000000000000000000000000 --env STORAGE_PATH=/home --env STORAGE_SIZE=5GB --env RPC_PORT=1234 --env RPC_ADDRESS=8.8.8.8  -v /path/on/host:/root/.xcore -v /path/on/host:/path/defined/in/STORAGE_PATH internxt-core
```

### Usage
If you want to check you Node you can garb a Bash with following command:

```
docker exec -it internxt /bin/bash
```

Afterwards you can use the usual xcore commands, eg:

```
root@34173ceba64b:/# xcore status
┌─────────────────────────────────────────────┬─────────┬──────────┬──────────┬─────────┬───────────────┬─────────┬──────────┬───────────┬──────────────┐
│ Node                                        │ Status  │ Uptime   │ Restarts │ Peers   │ Allocs        │ Delta   │ Port     │ Shared    │ Bridges      │
├─────────────────────────────────────────────┼─────────┼──────────┼──────────┼─────────┼───────────────┼─────────┼──────────┼───────────┼──────────────┤
│ 24265a65edafba1628ce7db623a4d2df5652ca6a    │ running │ 28s      │ 0        │ 0       │ 0             │ 8ms     │ ...      │ ...       │ connected    │
│   → /home                                   │         │          │          │         │ 0 received    │         │          │ (...%)    │              │
└─────────────────────────────────────────────┴─────────┴──────────┴──────────┴─────────┴───────────────┴─────────┴──────────┴───────────┴──────────────┘
```
#!/bin/bash
if [ -f .env ]; then
    source .env
fi

set -x #echo on

# set up the OM-backing Replica Set
function initRS() {
    NeedInit=$(docker exec on /bin/bash -c "mongosh --eval 'db.isMaster().primary'")
    if [ ! -z ${NeedInit} ]; then
        echo "Replica Set already initialized"
        return
    fi

    # init Replica Set
    docker exec on mongosh -f /var/lib/mongo/start/initRS.js
    # ID primary node
    while [ -z $primary ]; do
        primary=$(docker exec on /bin/bash -c 'mongosh --eval "db.isMaster()" | grep "primary"')
        primary=$(echo $primary | cut -d ":" -f 2 | cut -d "'" -f 2)
    done
    # create superuser
    docker exec ${primary} mongosh -f /var/lib/mongo/start/create1stUser.js
    # create other users
    docker exec ${primary} mongosh -u super -p super1234 -f /var/lib/mongo/start/createUsers.js
}

initRS

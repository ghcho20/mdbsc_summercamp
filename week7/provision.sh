#!/bin/bash
set -x #echo on

# init Replica Set, create users, and load data
docker cp start/initRS.js m1:/tmp/initRS.js
docker exec m1 mongosh -f /tmp/initRS.js

# ID primary node
while [ -z $primary ]; do
    sleep 2
    primary=$(docker exec m1 /bin/bash -c 'mongosh --eval "db.isMaster()" | grep "primary"')
    primary=$(echo $primary | cut -d ":" -f 2 | cut -d "'" -f 2)
done

set +x #echo off
echo "RS initiated, primary node is $primary"
#!/bin/bash
set -x #echo on

# init Replica Set, create users, and load data
docker exec m1 mongosh -f /var/lib/mongo/start/initRS.js

# ID primary node
while [ -z $primary ]; do
    primary=$(docker exec m1 /bin/bash -c 'mongosh --eval "db.isMaster()" | grep "primary"')
    primary=$(echo $primary | cut -d ":" -f 2 | cut -d "'" -f 2)
done

# create superuser
docker exec ${primary} mongosh -f /var/lib/mongo/start/create1stUser.js

# create other users
docker exec ${primary} mongosh -u super -p super1234 -f /var/lib/mongo/start/createUsers.js

# load data
docker exec m1 mongorestore --drop \
    --host="m1,m2,m3" \
    --port=27017 \
    --username=pm \
    --password=pm1234 \
    --authenticationDatabase=admin \
    /var/lib/mongo/start/load_data
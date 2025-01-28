#!/bin/bash

# load sample data
docker exec m1 mongorestore --drop \
    --host="m1,m2,m3" \
    --port=27017 \
    --username=pm \
    --password=pm1234 \
    --authenticationDatabase=admin \
    /var/lib/mongo/start/load_data
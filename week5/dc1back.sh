#!/bin/bash
set -x #echo on

docker cp ./dc1back.js m6:/tmp/dc1back.js

# reconfigure the replica set
docker exec m6 bash -c 'mongosh "mongodb://pm:pm1234@m4,m5,m6" -f /tmp/dc1back.js'
docker exec m6 rm -f /tmp/dc1back.js
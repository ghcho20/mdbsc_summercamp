#!/bin/bash
echo 120 > /proc/sys/net/ipv4/tcp_keepalive_time
echo 131060 > /proc/sys/vm/max_map_count
echo 1 > /proc/sys/vm/swappiness
echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null
echo never | tee /sys/kernel/mm/transparent_hugepage/defrag > /dev/null
chown -R root:root /data
mongod -f /etc/mongod.conf

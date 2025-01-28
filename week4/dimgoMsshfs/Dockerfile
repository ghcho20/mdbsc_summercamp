ARG IARCH
ARG EAVER
FROM ${IARCH:-arm64v8}/mongodb${EAVER}:om

ARG CONF=/root/.ssh/config
RUN dnf --enablerepo=powertools install -y fuse-sshfs sshpass;\
    dnf clean packages;\
    mkdir -p /root/.ssh;\
    echo 'StrictHostKeyChecking=no' > ${CONF};\
    echo 'UserKnownHostsFile=/dev/null' >> ${CONF};\
    echo 'Host on' >> ${CONF};\
    echo 'HostName on' >> ${CONF};\
    echo 'User root' >> ${CONF};\
    echo 'IdentityFile /root/.ssh/ombak' >> ${CONF};\
    ssh-keygen -t ed25519 -N '' -f /root/.ssh/ombak;\
    echo "sshpass -proot ssh-copy-id -i /root/.ssh/ombak.pub root@on" \
    >> /var/lib/mongo/start.sh;\
    echo -e "\nsshfs -o allow_other,default_permissions root@on:/root/snapshots /mnt/" \
    >> /var/lib/mongo/start.sh;\
    echo 'echo "sshfs mounted on /mnt"' >> /var/lib/mongo/start.sh;\
    echo 'ps' >> /var/lib/mongo/start.sh
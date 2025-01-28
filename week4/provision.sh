set -x #echo on

function provisionSSHd() {
    Check=$(docker exec on bash -c "[ -f /usr/sbin/sshd ] && echo 'true'")
    if [ -z ${Check} ]; then
        docker exec on dnf install -y openssh-server
        docker exec on dnf clean packages
        docker exec on bash -c "sed -i 's/\(GSSAPIAuthentication\).*/\1 no/' /etc/ssh/sshd_config"
        docker exec on bash -c "sed -i 's/.*ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config"
        docker exec on bash -c "sed -i 's/.*ClientAliveCountMax.*/ClientAliveCountMax 2/' /etc/ssh/sshd_config"
        docker exec on bash -c "sed -i 's/\(PermitRootLogin\).*/\1 yes/' /etc/ssh/sshd_config"
        docker exec on bash -c "sed -i 's/.*\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config"
        docker exec on bash -c "sed -i '\$a\AllowUsers root' /etc/ssh/sshd_config"
        docker exec on bash -c "echo 'root:root' | chpasswd"
        docker exec on mkdir -p /root/snapshots
        docker exec on ssh-keygen -A
    fi
    Check=$(docker exec on bash -c "ps | grep sshd | grep -v defunct | awk '{print \$NF}'")
    if [ -z ${Check} ]; then
        OPT=/etc/sysconfig/sshd
        CRYPTOPOL=/etc/crypto-policies/back-ends/opensshserver.config
        docker exec on bash -c "echo -e '\nsource ${OPT} && source ${CRYPTOPOL} && /usr/sbin/sshd -D \$OPTIONS \$CRYPTO_POLICY &' >> /var/lib/mongo/installConfig.sh"
        docker exec on bash -c "source ${OPT} && source ${CRYPTOPOL} && /usr/sbin/sshd -D "'$OPTIONS $CRYPTO_POLICY &'
        while [ -z $nologin ]; do
            nologin=$(docker exec on bash -c "[ -f /run/nologin ] && echo 'true'")
            sleep 1
        done
        docker exec on rm -f /run/nologin
    fi
}

function provisionSSHFS() {
    # for ci in o2 o3; do
    # install only on o2 due to memory shortcoming on docker VM
    for ci in o2; do
        Check=$(docker exec ${ci} bash -c "[ -f /usr/bin/sshfs ] && echo 'true'")
        if [ -z ${Check} ]; then
            docker exec ${ci} dnf --enablerepo=powertools install -y fuse-sshfs sshpass
            docker exec ${ci} dnf clean packages
            SSHCONF=/root/.ssh/config
            docker exec ${ci} mkdir -p /root/.ssh
            docker exec ${ci} bash -c "echo 'StrictHostKeyChecking=no' >> ${SSHCONF}"
            docker exec ${ci} bash -c "echo 'UserKnownHostsFile=/dev/null' >> ${SSHCONF}"
            docker exec ${ci} bash -c "echo 'Host on' >> ${SSHCONF}"
            docker exec ${ci} bash -c "echo 'HostName on' >> ${SSHCONF}"
            docker exec ${ci} bash -c "echo 'User root' >> ${SSHCONF}"
            docker exec ${ci} bash -c "echo 'IdentityFile /root/.ssh/ombak' >> ${SSHCONF}"
            docker exec ${ci} ssh-keygen -t ed25519 -N '' -f /root/.ssh/ombak
            docker exec ${ci} bash -c "echo -e '\nsshfs -o allow_other,default_permissions root@on:/root/snapshots/ /mnt/' >> /var/lib/mongo/installConfig.sh"
            docker exec ${ci} sshpass -proot ssh-copy-id -i /root/.ssh/ombak.pub root@on
            docker exec ${ci} sshfs -o allow_other,default_permissions root@on:/root/snapshots/ /mnt/
        fi
    done
}

provisionSSHd
provisionSSHFS
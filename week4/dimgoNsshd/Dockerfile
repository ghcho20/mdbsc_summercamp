ARG IARCH
ARG EAVER
FROM ${IARCH:-arm64v8}/mongodb${EAVER}:on

ARG OPT=/etc/sysconfig/sshd
ARG CRYPTOPOL=/etc/crypto-policies/back-ends/opensshserver.config
RUN dnf install -y openssh-server;\
    dnf clean packages;\
    sed -i 's/\(GSSAPIAuthentication\).*/\1 no/' /etc/ssh/sshd_config;\
    sed -i 's/.*ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config;\
    sed -i 's/.*ClientAliveCountMax.*/ClientAliveCountMax 2/' /etc/ssh/sshd_config;\
    sed -i 's/\(PermitRootLogin\).*/\1 yes/' /etc/ssh/sshd_config;\
    sed -i 's/.*\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config;\
    echo "AllowUsers root" >> /etc/ssh/sshd_config;\
    echo 'root:root' | chpasswd;\
    mkdir -p /root/snapshots;\
    ssh-keygen -A;\
    rm -f /run/nologin;\
    echo -e "\nsource ${OPT} && source ${CRYPTOPOL} && /usr/sbin/sshd -D \$OPTIONS \$CRYPTO_POLICY" \
    >> /var/lib/mongo/start.sh
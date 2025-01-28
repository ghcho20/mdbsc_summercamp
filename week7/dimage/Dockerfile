ARG IARCH
FROM ${IARCH:-arm64v8}/rockylinux:8

# install & common configuration
ARG EAVER
ARG REPOFILE=/etc/yum.repos.d/mongodb-enterprise-${EAVER}.repo
ARG RSNAME
RUN echo -e "[mongodb-enterprise-${EAVER}]" > ${REPOFILE};\
    echo -e "name=MongoDB Enterprise Repository" >> ${REPOFILE};\
    echo -e "baseurl=https://repo.mongodb.com/yum/redhat/$(cut -d'.' -f1 <<< ${EAVER})/mongodb-enterprise/${EAVER}/$(uname -m)/" >> ${REPOFILE};\
    echo -e "gpgcheck=1" >> ${REPOFILE};\
    echo -e "enabled=1" >> ${REPOFILE};\
    echo -e "gpgkey=https://pgp.mongodb.com/server-${EAVER}.asc" >> ${REPOFILE};\
    dnf install -y mongodb-enterprise iproute procps;\
    sed -i "s@/var/lib/mongo@/data@" /etc/mongod.conf;\
    sed -i "s@127.0.0.1@0.0.0.0@" /etc/mongod.conf;\
    sed -i "s@^#replication:@replication:\n  replSetName: ${RSNAME}@" /etc/mongod.conf;\
    sed -i "s@^#security:@security:\n  authorization: enabled\n  keyFile: /var/lib/mongo/rsAuthKey@" /etc/mongod.conf;\
    sed -i "/processManagement:/a\  fork: true" /etc/mongod.conf;\
    dnf clean packages

COPY rsAuthKey /var/lib/mongo/rsAuthKey
COPY start.sh /var/lib/mongo/start.sh
RUN chmod 600 /var/lib/mongo/rsAuthKey &&\
    chown root:root /var/lib/mongo/rsAuthKey &&\
    chmod +x /var/lib/mongo/start.sh &&\
    chown root:root /var/lib/mongo/start.sh

CMD ["/bin/bash", "-c", "/var/lib/mongo/start.sh && sleep infinity"]

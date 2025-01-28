ARG IARCH
ARG EAVER
FROM ${IARCH:-arm64v8}/mongodb${EAVER}:ea

# OM RS common configuration
ARG RSNAME
RUN sed -i "s@\(replSetName: \).*@\1${RSNAME}@" /etc/mongod.conf

# install OM
ARG OMFILE=mongodb-mms-7.0.12.500.20241029T1917Z.x86_64.rpm
ARG omdbusr
ARG omdbpwd
ARG omCentralUrl
ARG CONFFILE=/opt/mongodb/mms/conf/conf-mms.properties
RUN curl -o /tmp/${OMFILE} -OL https://downloads.mongodb.com/on-prem-mms/rpm/${OMFILE};\
    dnf install -y /tmp/${OMFILE};\
    dnf clean packages;\
    rm -f /tmp/${OMFILE};\
    # configure OM
    ## set OM DB connection string
    sed -i "s#\(^.*//\)127.0.0.1:27017\(.*\)#\1${omdbusr}:${omdbpwd}@on:27017,o2:27017,o3:27017\2#" ${CONFFILE};\
    ## OM Central URL for the agents
    echo "mms.centralUrl=${omCentralUrl}" >> ${CONFFILE};\
    ## OM DB URI
    echo "mongo.mongoUri=mongodb://pm:pm1234@on:27017,o2:27017,o3:27017" >> ${CONFFILE};\
    ## remote IP header for NGINX
    echo "mms.remoteIp.header=x-forwarded-for" >> ${CONFFILE};\
    ## ignore initial UI setup
    echo "mms.ignoreInitialUiSetup=true" >> ${CONFFILE};\
    # to pass pre-flight check without UI setup
    echo "mms.fromEmailAddr=g.cho@mongodb.com" >> ${CONFFILE};\
    echo "mms.replyToEmailAddr=g.cho@mongodb.com" >> ${CONFFILE};\
    echo "mms.adminEmailAddr=g.cho@mongodb.com" >> ${CONFFILE};\
    echo "mms.mail.transport=smtp" >> ${CONFFILE};\
    echo "mms.mail.hostname=localhost" >> ${CONFFILE};\
    echo "mms.mail.port=25" >> ${CONFFILE};\
    # run OM as root
    chown -R root:root /opt/mongodb/mms;\
    sed -i "s@\(MMS_USER=\).*@\1root@" /opt/mongodb/mms/conf/mms.conf;\
    echo 'rm -f /opt/mongodb/mms/logs/*' >> /var/lib/mongo/start.sh;\
    echo -e "\n/etc/init.d/mongodb-mms start" >> /var/lib/mongo/start.sh

COPY --chown=root:root gen.key /etc/mongodb-mms/

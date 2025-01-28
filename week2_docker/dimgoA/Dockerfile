ARG IARCH
ARG EAVER
FROM ${IARCH:-arm64v8}/mongodb${EAVER}:ea

# OM Agent: install & common configuration
ARG AConf=/etc/mongodb-mms/automation-agent.config
ARG agentRpm
ARG agentDownloadUrl=http://localhost:8082/download/agent/automation/${agentRpm}
ARG mmsGroupId
ARG mmsApiKey
ARG mmsBaseUrl
ARG httpProxy
ADD ${agentDownloadUrl} /tmp/agent.rpm
RUN dnf install -y /tmp/agent.rpm;\
    dnf clean packages;\
    rm -f /tmp/agent.rpm;\
    sed -i "s@.*mmsGroupId=.*@mmsGroupId=${mmsGroupId}@" ${AConf};\
    sed -i "s@.*mmsApiKey=.*@mmsApiKey=${mmsApiKey}@" ${AConf};\
    sed -i "s@.*mmsBaseUrl=.*@mmsBaseUrl=${mmsBaseUrl}@" ${AConf};\
    sed -i "s@.*httpProxy=.*@httpProxy=${httpProxy}@" ${AConf};\
    mkdir -p /var/run/mongodb-mms-automation;\
echo -e "\n/opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent -f ${AConf} \
-pidfilepath /var/run/mongodb-mms-automation/mongodb-mms-automation-agent.pid 2>&1 \
| /opt/mongodb-mms-automation/bin/fatallogger -logfile \
/var/log/mongodb-mms-automation/automation-agent-fatal.log&" \
>> /var/lib/mongo/start.sh

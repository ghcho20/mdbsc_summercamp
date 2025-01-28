ARG IARCH
ARG EAVER
FROM ${IARCH:-arm64v8}/mongodb${EAVER}:ea

# install & common configuration
ARG RSNAME
RUN sed -i "s@\(replSetName: \).*@\1${RSNAME}@" /etc/mongod.conf

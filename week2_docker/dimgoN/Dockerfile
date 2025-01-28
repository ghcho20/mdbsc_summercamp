ARG IARCH
ARG EAVER
FROM ${IARCH:-arm64v8}/mongodb${EAVER}:ea

# OM RS common configuration
ARG RSNAME
RUN sed -i "s@\(replSetName: \).*@\1${RSNAME}@" /etc/mongod.conf

# Nginx: install & common configuration
RUN dnf install -y nginx;\
    dnf clean packages

COPY loadbalancer.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/

RUN echo -e "\n/usr/sbin/nginx" >> /var/lib/mongo/start.sh
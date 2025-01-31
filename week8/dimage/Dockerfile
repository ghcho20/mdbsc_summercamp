FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine

RUN apk add --no-cache \
    vim \
    helm \
    kubectl \
    kubectx \
    git ;\
    echo 'Y' | gcloud components install gke-gcloud-auth-plugin ;\
    rm -f /usr/bin/vi; ln -s /usr/bin/vim /usr/bin/vi


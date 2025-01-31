source gcloud_env
set -x

gcloud container clusters get-credentials "$CLUSTER_NAME" \
  --zone="$ZONE"

gcloud container clusters list

#set context to master cluster
kubectx $(kubectx | grep "$CLUSTER_NAME" | awk '{print $1}')
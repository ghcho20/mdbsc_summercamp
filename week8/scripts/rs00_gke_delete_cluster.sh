source gcloud_env
set -x

gcloud container clusters delete "$CLUSTER_NAME" \
  --zone="$ZONE"

gcloud container clusters list
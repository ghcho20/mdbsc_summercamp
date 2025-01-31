source gcloud_env
set -x

# prerequisite: gcloud auth login via g.cho@gcp.corp.mongodb.com
# Will take a few minutes
gcloud container clusters create "$CLUSTER_NAME" \
  --zone "$ZONE" \
  --num-nodes=4 \
  --machine-type="${MACHINE}" \
  --cluster-version="${VERSION}" \
  --disk-type="pd-standard"
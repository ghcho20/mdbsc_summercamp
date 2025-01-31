source gcloud_env
set -x

# check OM cluster
kubectl -n "$NAMESPACE" get om
# get detailed overview
kubectl -n "$NAMESPACE" describe om ops-manager
# logs
# kubectl -n "$NAMESPACE" logs -f po/ops-manager-0
# events
# kubectl -n "$NAMESPACE" get events
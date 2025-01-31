source gcloud_env
set -x

helm get manifest enterprise-operator --namespace "${NAMESPACE}"

# disply CRDs
kubectl -n "${NAMESPACE}" get crd | grep -E '^(mongo|ops)'
# service accounts
kubectl -n "${NAMESPACE}" get sa | grep -E '^(mongo)'
# check if k8s operator was installed
kubectl describe deployments mongodb-enterprise-operator \
  -n "${NAMESPACE}"
# check watched namespaces
kubectl describe deploy mongodb-enterprise-operator \
  -n "${NAMESPACE}" | grep WATCH
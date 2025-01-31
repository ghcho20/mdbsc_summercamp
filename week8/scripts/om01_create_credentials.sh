source gcloud_env
set -x

kubectl $(kubectl | grep "master-operator" | awk '{print$1}')
kubectl get po -n "${NAMESPACE}"

kubectl -n "${NAMESPACE}" create secret generic om-admin-secret \
  --from-literal=Username="omsmanager@example.com" \
  --from-literal=Password="p@ssword123" \
  --from-literal=FirstName="Ops" \
  --from-literal=LastName="Manager"
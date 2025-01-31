source gcloud_env
set -x

helm repo add mongodb https://mongodb.github.io/helm-charts
kubectl create ns "${NAMESPACE}"
helm install enterprise-operator mongodb/enterprise-operator \
  --namespace="${NAMESPACE}" \
  --version="${HELM_CHART_VERSION}" \
  --set operator.watchNamespace="${NAMESPACE}"

kubectl get ns
kubectl get po -n "${NAMESPACE}"
helm list --namespace="${NAMESPACE}"
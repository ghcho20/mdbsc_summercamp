source gcloud_env
set -x

# Wait for the Ops Manager to be ready
kubectl -n "${NAMESPACE}" get pods
kubectl -n "${NAMESPACE}" get pvc
kubectl -n "${NAMESPACE}" get sts
kubectl -n "${NAMESPACE}" get svc

# OM LB URL
URL=http://$(kubectl -n "${NAMESPACE}" get svc ops-manager-svc-ext -o jsonpath='{.status.loadBalancer.ingress[0].ip}:{.spec.ports[0].port}')
echo $URL

# Update spec.configuration.mms.centralUrl to reflect LB URL
# via kubectl patch
kubectl -n "${NAMESPACE}" patch om ops-manager --type=merge -p "{\"spec\":{\"configuration\":{\"mms.centralUrl\":\"${URL}\"}}}"
# Wait for the OM pod(ops-manager-0) to restart
# and LB also to be ready
RESTARTED=
while [ -z "$RESTARTED" ]; do
  sleep 5
  RESTARTED=$(kubectl -n "${NAMESPACE}" get pods ops-manager-0 | grep "Running")
done

set +x
echo "Ops Manager is ready at: ${URL}"
source gcloud_env
set -x

kubectl apply -f - <<EOF
apiVersion: mongodb.com/v1
kind: MongoDBOpsManager
metadata:
  name: ops-manager
  namespace: "${NAMESPACE}"
spec:
  version: "${OM_VERSION}"
  adminCredentials: om-admin-secret
  externalConnectivity:
    type: LoadBalancer
  configuration:
    mms.ignoreInitialUiSetup: "true"
    automation.versions.source: mongodb
    mms.adminEmailAddr: support@example.com
    mms.fromEmailAddr: support@example.com
    mms.replyToEmailAddr: support@example.com
    mms.mail.hostname: example.com
    mms.mail.port: "465"
    mms.mail.ssl: "false"
    mms.mail.transport: smtp
  # the Replica Set backing Ops Manager.
  applicationDatabase:
    members: 3
    version: "${APPDB_VERSION}"
EOF
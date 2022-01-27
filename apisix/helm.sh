helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add apisix https://charts.apiseven.com
helm repo update
helm install apisix apisix/apisix \
  --namespace ingress-apisix \
  --set gateway.type=LoadBalancer \
  --set admin.allow.ipList="{0.0.0.0/0}" \
  --set dashboard.enabled=true \
  --set etcd.persistence.storageClass="nfs-storage-class" \
  --set etcd.persistence.size="2Gi" \
  --set ingress-controller.enabled=true

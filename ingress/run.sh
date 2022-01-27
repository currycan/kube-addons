# /bin/env bash

kubectl label nodes k8s-all-in-one ingress-ready=true
kubectl apply -f .


# https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/README.md
# helm install
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
# helm show values ingress-nginx/ingress-nginx
# --set controller.kind=DaemonSet \
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  --set controller.dnsPolicy=ClusterFirstWithHostNet \
  --set controller.hostNetwork=true \
  --set controller.kind=Deployment \
  --set controller.replicaCount=1 \
  --set controller.admissionWebhooks.enabled=true \
  --set metrics.enabled=true \
  --set serviceMonitor.enabled=false \
  --set prometheusRule.enabled=false \
  --set defaultBackend.enabled=false

helm pull ingress-nginx/ingress-nginx
tar zxvf ingress-nginx-4.0.16.tgz
helm install ingress-nginx . \
  --create-namespace \
  --namespace ingress-nginx \
  --set controller.admissionWebhooks.patch.image.registry=docker.io \
  --set controller.admissionWebhooks.patch.image.image=currycan/ingress-nginx-kube-webhook-certgen \
  --set controller.admissionWebhooks.patch.image.tag=v1.1.1 \
  --set controller.admissionWebhooks.patch.image.digest='' \
  --set controller.image.registry=docker.io \
  --set controller.image.image=currycan/ingress-nginx-controller \
  --set controller.image.tag=v1.1.1 \
  --set controller.image.digest='' \
  --set controller.dnsPolicy=ClusterFirstWithHostNet \
  --set controller.hostNetwork=true \
  --set controller.kind=Deployment \
  --set controller.replicaCount=1 \
  --set controller.admissionWebhooks.enabled=true \
  --set metrics.enabled=true \
  --set serviceMonitor.enabled=false \
  --set prometheusRule.enabled=false \
  --set defaultBackend.enabled=false

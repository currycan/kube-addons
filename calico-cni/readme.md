# 说明

## 安装

[Install using Helm](https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm)

```bash
helm repo add projectcalico https://docs.projectcalico.org/charts
kubectl create namespace tigera-operator
helm install calico projectcalico/tigera-operator --namespace tigera-operator --version v3.24.0
```

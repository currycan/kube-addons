# 说明

## 安装

[Install using Helm](https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm)


```bash
# helm show values projectcalico/tigera-operator --version v3.25.0
helm repo add projectcalico https://docs.projectcalico.org/charts
helm repo update
cat > values.yaml <<EOF
installation:
  cni:
    type: Calico
  calicoNetwork:
    bgp: Disabled
    ipPools:
    - cidr: 172.30.0.0/16
      encapsulation: VXLAN
    nodeAddressAutodetectionV4:
      interface: eth0
      canReach: 172.17.0.0
EOF
# kubectl delete crd apiservers.operator.tigera.io
# kubectl delete ns tigera-operator

# kubectl create namespace tigera-operator
version=3.22.5
# version=3.21.6
# version=3.20.6
curl -o /usr/local/bin/calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.20.6/calicoctl"
chmod +x /usr/local/bin/calicoctl

helm install calico projectcalico/tigera-operator -f values.yaml --version v${version}
```

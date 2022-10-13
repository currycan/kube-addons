# 安装

```bash
helm repo add cilium https://helm.cilium.io/

# helm uninstall -n kube-system cilium
# helm upgrade cilium cilium/cilium --version 1.9.18 \
helm install cilium cilium/cilium --version 1.9.18 \
  --namespace kube-system \
  --set tunnel=disabled \
  --set autoDirectNodeRoutes=true \
  --set kubeProxyReplacement=strict \
  --set loadBalancer.mode=hybrid \
  --set prometheus.enabled=true \
  --set operator.prometheus.enabled=true \
  --set nativeRoutingCIDR=172.30.0.0/16 \
  --set ipam.mode=kubernetes \
  --set k8sServiceHost=apiserver.cluster.local \
  --set k8sServicePort=6443 \
  --set cluster.name=test-demo \
  --set cluster.id=66 \
  --set operator.replicas=1 \
  --set metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true

node=crd-k8s
kubectl taint node ${node} node-role.kubernetes.io/master-

kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTNETWORK:.spec.hostNetwork --no-headers=true | grep '<none>' | awk '{print "-n "$1" "$2}' | xargs -L 1 -r kubectl delete pod

curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}
```

## 初始化不安装 kube-proxy

```bash
kubeadm init --skip-phases=addon/kube-proxy
```

## 已安装，卸载 kube-proxy

```bash
kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete cm kube-proxy
# Run on each node with root permissions:
# iptables-save | grep -v KUBE | iptables-restore
ipvsadm-save | ipvsadm-restore
```

## 不兼容 1.18.20

```bash
helm install cilium cilium/cilium --version 1.12.1 \
helm install cilium cilium/cilium --version 1.11.18 \
helm install cilium cilium/cilium --version 1.10.14 \

```
## 兼容 1.18.20

cilium 安装工具

```bash
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm -f cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
```

hubble 安装工具

```bash
export HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
curl -L --remote-name-all https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check hubble-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC hubble-linux-amd64.tar.gz /usr/local/bin
rm hubble-linux-amd64.tar.gz{,.sha256sum}
```

```bash
cilium install --version 1.9.18 \
  --helm-set tunnel=disabled \
  --helm-set autoDirectNodeRoutes=true \
  --helm-set kubeProxyReplacement=strict \
  --helm-set loadBalancer.mode=hybrid \
  --helm-set prometheus.enabled=true \
  --helm-set operator.prometheus.enabled=true \
  --helm-set nativeRoutingCIDR=172.30.0.0/16 \
  --helm-set ipam.mode=kubernetes \
  --helm-set k8sServiceHost=apiserver.cluster.local \
  --helm-set k8sServicePort=6443 \
  --helm-set cluster.name=test-demo \
  --helm-set cluster.id=66 \
  --helm-set operator.replicas=1 \
  --helm-set metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"

cilium hubble enable
```

此时会报错：MountVolume.SetUp failed for volume "tls" : configmap "hubble-ca-cert" not found

手动生成 yaml，然后 appliy

````bash
helm template cilium cilium/cilium  --version 1.9.18 \
  --namespace kube-system \
  --set tunnel=disabled \
  --set autoDirectNodeRoutes=true \
  --set kubeProxyReplacement=strict \
  --set loadBalancer.mode=hybrid \
  --set prometheus.enabled=true \
  --set operator.prometheus.enabled=true \
  --set nativeRoutingCIDR=172.30.0.0/16 \
  --set ipam.mode=kubernetes \
  --set k8sServiceHost=apiserver.cluster.local \
  --set k8sServicePort=6443 \
  --set cluster.name=test-demo \
  --set cluster.id=66 \
  --set operator.replicas=1 \
  --set metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true > cilium.yaml

kubectl apply -f cilium.yaml

```

kubectl patch svc hubble-ui -n kube-system -p '{"spec": {"type": "LoadBalancer"}}'

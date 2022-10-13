# 安装

```bash
helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.12.1 \
  --namespace kube-system

--enable-ipv4-masquerade

# helm uninstall -n kube-system cilium
helm upgrade cilium cilium/cilium --version 1.12.1 \
helm install cilium cilium/cilium --version 1.12.1 \
  --namespace kube-system \
  --set cluster.name=test-demo \
  --set cluster.id=66 \
  --set operator.replicas=1 \
  --set kubeProxyReplacement=strict \
  --set tunnel=disabled \
  --set ipam.mode=kubernetes \
  --set enableIPv4Masquerade=true \
  --set ipam.operator.clusterPoolIPv4PodCIDR=172.30.0.0/16 \
  --set k8s.requireIPv4PodCIDR=true \
  --set ipam.operator.clusterPoolIPv4MaskSize=24 \
  --set datapathMode=veth \
  --set debug.enabled=true \
  --set nodeinit.enabled=true \
  --set localRedirectPolicy=true \
  --set bandwidthManager.enabled=true \
  --set bandwidthManager.bbr=true \
  --set externalIPs.enabled=true \
  --set nodePort.enabled=true \
  --set hostPort.enabled=true \
  --set installIptablesRules=true  \
  --set installNoConntrackIptablesRules=true \
  --set wellKnownIdentities.enabled=true \
  --set metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
  --set prometheus.enabled=true \
  --set operator.prometheus.enabled=true \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true \
  --set rollOutCiliumPods=true \
  --set bpf.clockProbe=true \
  --set bpf.preallocateMaps=true \
  --set ipv4.enabled=true \
  --set ipv6.enabled=false \
  --set monitor.enabled=true \
  --set l7Proxy=true

node=crd-k8s
kubectl taint node ${node} node-role.kubernetes.io/master-

kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTNETWORK:.spec.hostNetwork --no-headers=true | grep '<none>' | awk '{print "-n "$1" "$2}' | xargs -L 1 -r kubectl delete pod

curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}
```

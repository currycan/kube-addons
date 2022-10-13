# 安装

```bash
helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.11.0 \
  --namespace kube-system

# 1.11 报错 network: Unable to create endpoint: Cilium API client timeout exceeded
# helm upgrade cilium cilium/cilium --version 1.11.0 \
helm install cilium cilium/cilium \
  --namespace kube-system \
  --set debug.enabled=true \
  --set nodeinit.enabled=true \
  --set cluster.id=66 \
  --set cluster.name=test-demo \
  --set localRedirectPolicy=true \
  --set bandwidthManager=true \
  --set externalIPs.enabled=true \
  --set nodePort.enabled=true \
  --set hostPort.enabled=true \
  --set hostServices.enabled=true \
  --set hostServices.protocols=tcp \
  --set installNoConntrackIptablesRules=true \
  --set wellKnownIdentities.enabled=true \
  --set enableK8sEndpointSlice=true \
  --set operator.replicas=1 \
  --set metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
  --set kubeProxyReplacement=strict \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true \
  --set datapathMode=veth \
  --set tunnel=disabled \
  --set autoDirectNodeRoutes=true \
  --set installIptablesRules=true  \
  --set nativeRoutingCIDR=172.30.0.0/16 \
  --set rollOutCiliumPods=true \
  --set bgp.enabled=false \
  --set bgp.announce.loadbalancerIP=true \
  --set bpf.clockProbe=true \
  --set bpf.preallocateMaps=true \
  --set ipam.mode=cluster-pool \
  --set ipam.operator.clusterPoolIPv4PodCIDR=172.30.0.0/16 \
  --set ipam.operator.clusterPoolIPv4MaskSize=24 \
  --set ipam.operator.clusterPoolIPv6PodCIDR=fd00::/104 \
  --set ipam.operator.clusterPoolIPv6MaskSize=120 \
  --set ipv4.enabled=true \
  --set ipv6.enabled=false \
  --set egressGateway.enabled=true \
  --set monitor.enabled=true \
  --set l7Proxy=true \
  --set ipvlan.masterDevice=eth0 \
  --set k8sServiceHost=172.16.0.2 \
  --set k8sServicePort=6443

node=crd-k8s
kubectl taint node ${node} node-role.kubernetes.io/master-

kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTNETWORK:.spec.hostNetwork --no-headers=true | grep '<none>' | awk '{print "-n "$1" "$2}' | xargs -L 1 -r kubectl delete pod

curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}
```

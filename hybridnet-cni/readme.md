
# 说明

[Home(简体中文) · alibaba/hybridnet Wiki](https://github.com/alibaba/hybridnet/wiki/Home(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

##  helm 安装

**vxlanID 值需从 1-4094**

```bash
helm repo add hybridnet https://alibaba.github.io/hybridnet/
helm repo update
helm upgrade --install hybridnet hybridnet/hybridnet -n kube-system \
  --set init.cidr="172.30.0.0/16" \
  --set init.ipVersion=4 \
  --set init.vxlanID=10 \
  --set manager.replicas=1 \
  --set webhook.replicas=1 \
  --set typha.replicas=1 \
  --set defaultNetworkType=Overlay \
  --set multiCluster=false
```

多节点集群：

```bash
helm upgrade --install hybridnet hybridnet/hybridnet -n kube-system \
  --set init.cidr="172.30.0.0/16" \
  --set init.ipVersion=4 \
  --set init.vxlanID=10 \
  --set defaultNetworkType=Overlay \
  --set multiCluster=false
```

查看网络配置：

```bash
kubectl get networks.networking.alibaba.com
kubectl get subnets.networking.alibaba.com
kubectl get ipinstances.networking.alibaba.com -A
```

# 配置网络

[hybridnet/vxlan-overlay.yaml at main · alibaba/hybridnet](https://github.com/alibaba/hybridnet/blob/main/samples/vxlan-overlay.yaml)

```yaml
---
apiVersion: networking.alibaba.com/v1
kind: Network
metadata:
  name: overlay-network
spec:
  netID: 11
  type: Overlay

---
apiVersion: networking.alibaba.com/v1
kind: Subnet
metadata:
  name: overlay-subnet
spec:
  network: overlay-network                            # 必填
  netID: 11                                            # 如果是 VXLAN/BGP 网络，该字段不填；
                                                      # 对于 VLAN 网络，如果 Network 的 spec.netID 为空，Subnet 的 spec.netID 一定不能为空
                                                      # 如果 Network 的 spec.netID 不为空，Subnet 的 spec.netID
  range:
    version: "4"                                      # 必填，"4" or "6", for ipv4 or ipv6.
    cidr: "192.168.0.0/24"                            # 必填
    gateway: "192.168.0.1"                            # 如果是 VLAN 网络，必填；其他类型网络不填
    start: "192.168.0.100"                            # 可选，cidr 里第一个可用来分配的 IP
    end: "192.168.0.200"                              # 可选，cidr 里最后一个可用来分配的 IP
    reservedIPs: ["192.168.0.101","192.168.0.102"]    # 可选，保留不分配的 IP，可以被 “指定” 使用
    excludeIPs: ["192.168.0.103","192.168.0.104"]     # 可选，不用来分配的零散 IP
```

### underlay

需要提前给节点打上标签：

```bash
kubectl label nodes 10.10.10.6 network=underlay
```

```yaml
---
apiVersion: networking.alibaba.com/v1
kind: Network
metadata:
  name: underlay-network
spec:
  netID: 0
  type: Underlay
  nodeSelector:
    network: "underlay"
---
apiVersion: networking.alibaba.com/v1
kind: Subnet
metadata:
  name: underlay-subnet
spec:
  network: underlay-network
  netID: 0
  range:
    version: "4"
    cidr: "10.10.10.0/24"
    gateway: "10.10.10.254"
    start: "10.10.10.50"
    end: "10.10.10.99"
    reservedIPs: ["10.10.10.52","10.10.10.53"]
    excludeIPs: ["10.10.10.254","10.10.10.243"]
```

## 默认关闭 sts ip 保持

```bash
helm upgrade hybridnet hybridnet/hybridnet -n kube-system --set defaultIPRetain=false --reuse-values
```


## 卸载
```
helm uninstall -n kube-system hybridnet

kubectl delete networks.networking.alibaba.com init
kubectl delete subnets.networking.alibaba.com init
kubectl delete ipinstances.networking.alibaba.com xxx

ip link del  eth0.vxlan10

```
VERSION=v1.8.0

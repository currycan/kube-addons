
# 说明

[Home(简体中文) · alibaba/hybridnet Wiki](https://github.com/alibaba/hybridnet/wiki/Home(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

##  helm 安装

```bash
helm repo add hybridnet https://alibaba.github.io/hybridnet/
helm repo update
helm install hybridnet hybridnet/hybridnet -n kube-system \
  --set init.withoutNetwork=true \
  --set manager.replicas=1 \
  --set webhook.replicas=1 \
  --set defaultNetworkType=Overlay \
  --set multiCluster=false
```

## 配置网络

[hybridnet/vxlan-overlay.yaml at main · alibaba/hybridnet](https://github.com/alibaba/hybridnet/blob/main/samples/vxlan-overlay.yaml)

```yaml
---
apiVersion: networking.alibaba.com/v1
kind: Network
metadata:
  name: overlay-network
spec:
  netID: 4
  type: Overlay

---
apiVersion: networking.alibaba.com/v1
kind: Subnet
metadata:
  name: overlay-subnet
spec:
  network: overlay-network
  range:
    version: "4"
    cidr: "172.30.0.0/16"
```

### underlay

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
    network: "network"
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
    start: "10.10.10.100"
    end: "10.10.10.200"
    reservedIPs: ["10.10.10.101","10.10.10.102"]
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

```
VERSION=v1.8.0
https://github.com/vmware-tanzu/antrea/releases/download/$VERSION/antrea.yml

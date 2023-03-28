
# 安装

https://antrea.io/docs/v1.8.0/docs/helm/

```bash
helm repo add antrea https://charts.antrea.io
helm repo update
helm install antrea antrea/antrea --namespace kube-system

```
VERSION=v1.8.0
https://github.com/vmware-tanzu/antrea/releases/download/$VERSION/antrea.yml

## 修改 configmap

```yaml
  antrea-controller.conf: |
    ...
    featureGates:
      AntreaIPAM: true
    ...
  antrea-agent.conf: |
    ...
    featureGates:
      AntreaIPAM: true
    ...
```

## 创建 IP 池

```yaml
apiVersion: "crd.antrea.io/v1alpha2"
kind: IPPool
metadata:
  name: pool1
spec:
  ipVersion: 4
  ipRanges:
  - start: "172.30.0.5"
    end: "172.30.0.7"
    gateway: "172.30.0.1"
    prefixLength: 24
    vlan: 2              # Default is 0 (untagged). Valid value is 0~4095.
```

## 创建固定 IP namespace

kubectl annotate ns default ipam.antrea.io/ippools='pool1'

```yaml
kind: StatefulSet
spec:
  replicas: 1  # Do not increase replicas if there is pod-ips annotation in PodTemplate
  template:
    metadata:
      annotations:
        ipam.antrea.io/ippools: 'pool1'
        ipam.antrea.io/pod-ips: '172.30.0.5'
...
```
ipam.antrea.io/ippools: 'pool1'

  annotations:
    ipam.antrea.io/pod-ips: '172.30.0.5'



crd.antrea.io/v1beta1

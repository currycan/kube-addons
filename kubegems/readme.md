# 说明

## 配置修改

- 使用阿里镜像

- 对于低版本k8s集群，修改 `apiextensions.k8s.io/v1` 为 `apiextensions.k8s.io/v1beta1`

## 部署

- 安装 KubeGems Installer crd 控制器

```bash
kubectl apply -f centrol.yaml
```

- 安装 installer 资源

```bash
kubectl apply -f centrol.installer.yaml
```

helm upgrade --install sreworks ./ \
    --create-namespace --namespace sreworks \
    --set global.accessMode="nodePort" \
    --set appmanager.home.url="http://10.10.10.49:30767" \
    --set global.storageClass="nfs-storage-class" \
    --set appmanagerbase.openebs.enabled=false


kubectl create namespace kubegems-installer
kubectl apply -f https://github.com/kubegems/kubegems/raw/main/deploy/installer.yaml
export STORAGE_CLASS=nfs-storage-class
export KUBEGEMS_VERSION=v1.21.1
curl -sL https://raw.githubusercontent.com/kubegems/kubegems/main/deploy/kubegems-mirror.yaml \
| sed -e "s/local-path/${STORAGE_CLASS}/g" -e "s/latest/${KUBEGEMS_VERSION}/g" \
> kubegems.yaml

kubectl create namespace kubegems
kubectl apply -f kubegems.yaml

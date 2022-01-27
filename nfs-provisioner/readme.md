# 说明

安装 nfs server

```bash
yum install nfs-utils rpcbind -y
systemctl enable --now rpcbind.service
systemctl enable --now nfs.service
mkdir -p /nfs/data
chown nfsnobody:nfsnobody /nfs/data
echo "/nfs/data 172.17.16.17/20(rw,sync,no_root_squash)">>/etc/exports
echo "/nfs/data 127.0.0.1(rw,sync,no_root_squash)">>/etc/exports
exportfs -rv
showmount -e localhost
```

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo 'source <(helm completion bash)' >>~/.bashrc
. ~/.bashrc
helm repo add stable http://mirror.azure.cn/kubernetes/charts
```

helm 安装

```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --namespace kube-system \
  --set nfs.server=10.10.10.3 \
  --set nfs.path=/nfs/data \
  --set storageClass.name=nfs-storage-class \
  --set storageClass.reclaimPolicy=Delete \
  --set storageClass.accessModes=ReadWriteMany
```

```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --namespace kube-system \
  --set nfs.server=10.0.1.4 \
  --set nfs.path=/nfs/data \
  --set storageClass.name=nfs-storage-class \
  --set storageClass.reclaimPolicy=Delete \
  --set storageClass.accessModes=ReadWriteMany
```

```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --namespace kube-system \
  --set nfs.server=172.16.0.2 \
  --set nfs.path=/nfs/data \
  --set storageClass.name=nfs-storage-class \
  --set storageClass.reclaimPolicy=Delete \
  --set storageClass.accessModes=ReadWriteMany
```

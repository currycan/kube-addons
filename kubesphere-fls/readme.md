# 说明

## etcd 密钥

```bash
kubectl create ns kubesphere-monitoring-system
kubectl -n kubesphere-monitoring-system create secret generic kube-etcd-client-certs  \
--from-file=etcd-client-ca.crt=/etc/kubernetes/pki/etcd/ca.crt  \
--from-file=etcd-client.crt=/etc/kubernetes/pki/etcd/healthcheck-client.crt  \
--from-file=etcd-client.key=/etc/kubernetes/pki/etcd/healthcheck-client.key
```

- 重建后 webhook 有问题，删除

```bash
kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io users.iam.kubesphere.io
```

- redis 缓存有问题，删掉

```bash
kubectl edit cm -n kubesphere-system kubesphere-config
```

- 删除 kubesphere-system 下的 ks-installer deployment, 否则每次修改重启后被覆盖

```bash
kubectl delete deployments.apps -n kubesphere-system ks-installer
```

kubectl get clusterconfigurations.installer.kubesphere.io -n kubesphere-system ks-installer

kubectl get clusters.cluster.kubesphere.io

```yaml
redis:
  host: redis.kubesphere-system.svc
  port: 6379
  password: KUBESPHERE_REDIS_PASSWORD
  db: 0
```

- 编辑 crd 资源

```bash
kubectl get clusterconfigurations.installer.kubesphere.io -n kubesphere-system ks-installer
```

## 参考

[KubeSphere 3.2.x 卸载可插拔组件](https://kubesphere.io/zh/docs/pluggable-components/uninstall-pluggable-components/)

## 地址

Console: http://192.168.0.2:30880
Account: admin
Password: P@88w0rd

## 资源管理

创建用户 --> 创建企业空间 --> 在企业空间里创建项目

kubectl get workspacetemplates.tenant.kubesphere.io fls-abc

kubectl create ns nginx
kubectl label ns nginx kubesphere.io/workspace=fls-abc

## 灰度

kubectl get strategies.servicemesh.kubesphere.io -n default

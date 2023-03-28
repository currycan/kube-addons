# 安装

## 创建配置文件

- 单机

```bash
sealos run labring/kubernetes:v1.25.0 labring/helm:v3.8.2 labring/calico:v3.24.1 --single
```

- 集群

```bash
sealos gen labring/kubernetes:v1.25.0 labring/helm:v3.8.2 labring/calico:v3.24.1 \
  --masters 10.10.10.1,10.10.10.2,10.10.10.3 \
  --nodes 10.10.10.4,10.10.10.5,10.10.10.6 \
  --pk /root/.ssh/id_ed25519 --user root --cluster demo > Clusterfile
```

## 安装

```bash
sealos apply -f Clusterfile --debug
```

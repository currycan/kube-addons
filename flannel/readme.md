# 说明

- 初始化时，需要先删除 `/etc/cni/net.d` 下的其他配置，如： 10-containerd-net.conflist
- cni0 重新配置

```bash
ifconfig cni0 down
ip link delete cni0
```

ip-masq-agent 是一个用来管理 IP 伪装的扩展，即管理节点中 IP 网段的 SNAT 规则。

```bash
cat >config <<EOF
nonMasqueradeCIDRs:
  - 172.30.0.0/16
resyncInterval: 60s
EOF
```

kubectl create configmap ip-masq-agent --from-file=config --namespace=kube-system

- 默认情况下，安装 docker 后 docker0 的网段是: 172.17.0.1/16,如果将 pod 的网段也设置为 172.17.0.1/16，就会出现网段冲突。

修改 docker.service 配置相关参数：

```text
EnvironmentFile=/run/flannel/subnet.env

--bip=${FLANNEL_SUBNET} --ip-masq=false --mtu=${FLANNEL_MTU}
```

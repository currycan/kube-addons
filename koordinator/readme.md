# 安装

[koordinator-sh/charts: Koordinator Helm Charts.](https://github.com/koordinator-sh/charts)

```bash
helm repo add koordinator-sh https://koordinator-sh.github.io/charts/
helm repo update
helm upgrade --install koordinator koordinator-sh/koordinator \
    --set imageRepositoryHost=registry.cn-hangzhou.aliyuncs.com \
    --set manager.replicas=1 \
    --set scheduler.replicas=1 \
    --set descheduler.replicas=1 \
    --set manager.resources.requests.cpu='10m' \
    --set scheduler.resources.requests.cpu='10m' \
    --set descheduler.resources.requests.cpu='10m' \
   --version 1.1.1
```

## demo

配置  ClusterColocationProfile[ccp.yaml](./ccp.yaml)

部署 demo [ccp-demo.yaml](./ccp-demo.yaml)

需要开启服务定级的 namespace 打标：

```bash
kubectl label ns default enable-koordinator=true
```

## 测试验证：

yum install -y httpd-tools stress-ng

stress-ng --cpu 4 --cpu-method fft --timeout 2m

ab -n 1000000 -c 200 -r "http://172.31.155.5/"

version=0.7.0
wget https://github.com/koordinator-sh/koordinator/releases/download/v${version}/koord-runtime-proxy_${version}_linux_x86_64 -O koord-runtime-proxy
chmod +x koord-runtime-proxy

koord-runtime-proxy \
   --backend-runtime-mode=Docker \
   --remote-runtime-service-endpoint=/var/run/docker.sock

cat << EOF > /lib/systemd/system/koord-runtime-proxy.service
[Unit]
Description=koord runtimeproxy
Documentation=https://koordinator.sh/
After=network.target

[Service]
ExecStart=/usr/local/bin/koord-runtime-proxy \
   --backend-runtime-mode=Docker \
   --remote-runtime-service-endpoint=/var/run/dockershim.sock

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=1048576
TasksMax=infinity
StartLimitBurst=3
OOMScoreAdjust=-999
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now koord-runtime-proxy.service
systemctl daemon-reload && systemctl restart koord-runtime-proxy.service

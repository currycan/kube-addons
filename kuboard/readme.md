# 说明

KUBOARD_ENDPOINT 参数的作用是，让部署到 Kubernetes 中的 kuboard-agent 知道如何访问 Kuboard Server,配置成 nodePort 地址

在浏览器输入 http://your-host-ip:80 即可访问 Kuboard v3.x 的界面，登录方式：
用户名： admin
密 码： Kuboard123

```bash
kubectl create secret tls txk-ing --cert 1_txk.ztaoz.com_bundle.crt --key 2_txk.ztaoz.com.key -n kuboard
kubectl create ingress kuboard -n kuboard --class=nginx --rule="txk.ztaoz.com/*=kuboard-v3:80,tls=txk-ing"
```

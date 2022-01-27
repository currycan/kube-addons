# 说明

## 创建 ks 资源

kubectl apply -f ks.yaml

kubectl get applications.app.k8s.io

- workspace spec 绑定集群和用户
- namespace label 绑定 workspace
- app 需要指定 namespace，label 标明 名字和版本

## 创建应用

kubectl apply -f demo.yaml

- service label 绑定 app
- deploymne label 绑定 app
- istio gw 个 vs-gw 暴露服务

## 灰度

kubectl apply -f gray.yaml

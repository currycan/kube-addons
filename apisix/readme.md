# 说明

- apisix 安装依赖 etcd,etcd 安装使用 bitnami charts
- 1.22 版本废弃了 v1beta1 版本的 crd，helm暂时不支持
- etcd 依赖参数，通过 etcd.xxx.xxx 来配置
- helm 现有默认 ingress 版本过低，需要手动为 dashboard 创建 ingress
- dashboard 默认密码：admin/admin

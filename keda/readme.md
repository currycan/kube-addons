# 安装使用

[Deploying KEDA | KEDA](https://keda.sh/docs/2.9/deploy/)

k8s 1.18 只支持 2.8.x 版本，如：2.8.4

```bash
helm repo add kedacore https://kedacore.github.io/charts
helm repo update

helm install keda kedacore/keda \
  --create-namespace --namespace keda \
  --version 2.8.4
```

redis 写入数据：

LPUSH scaler 1 2 3 4 5 6
LLEN scaler
LREM scaler 3 1
LREM scaler 3 2

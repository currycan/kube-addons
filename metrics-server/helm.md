# 安装

[metrics-server/README.md at master · kubernetes-sigs/metrics-server](https://github.com/kubernetes-sigs/metrics-server/blob/master/charts/metrics-server/README.md)

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm upgrade --install metrics-server metrics-server/metrics-server -n kube-system

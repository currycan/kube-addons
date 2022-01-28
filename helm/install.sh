#! /bin/env bash

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo 'source <(helm completion bash)' >>~/.bashrc
. ~/.bashrc
helm repo add stable http://mirror.azure.cn/kubernetes/charts
helm repo add bitnami https://charts.bitnami.com/bitnami

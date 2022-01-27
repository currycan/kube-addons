# /bin/env bash

set -e

# 创建一个根证书
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=test Inc./CN=test.com' -keyout test.com.key -out test.com.crt

# 创建 httpbin.test.com 证书和私钥
openssl req -out httpbin.test.com.csr -newkey rsa:2048 -nodes -keyout httpbin.test.com.key -subj "/CN=httpbin.test.com/O=httpbin organization"
openssl x509 -req -days 365 -CA test.com.crt -CAkey test.com.key -set_serial 0 -in httpbin.test.com.csr -out httpbin.test.com.crt

# 创建 bki.test.com 证书和私钥
openssl req -out bki.test.com.csr -newkey rsa:2048 -nodes -keyout bki.test.com.key -subj "/CN=bki.test.com/O=bookinfo organization"
openssl x509 -req -days 365 -CA test.com.crt -CAkey test.com.key -set_serial 0 -in bki.test.com.csr -out bki.test.com.crt

# 该 secret 必须在 istio-system 命名空间下，且名为 istio-ingressgateway-xxxx-certs，以与此任务中使用的 Istio 默认 ingress 网关的配置保持一致
kubectl create -n istio-system secret tls istio-ingressgateway-certs --key httpbin.test.com.key --cert httpbin.test.com.crt

kubectl create -n istio-system secret tls istio-ingressgateway-bookinfo-certs --key bki.test.com.key --cert bki.test.com.crt

# 查看证书情况
kubectl exec -it -n istio-system $(kubectl -n istio-system get pods -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -- ls -al /etc/istio/ingressgateway-certs

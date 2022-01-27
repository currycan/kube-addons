# 说明

## patch

```bash
# --type must be one of [json merge strategic], not "yaml"
kubectl patch -n istio-system deployments.apps istio-ingressgateway --type=json -p "$(cat gw-tls-patch.json)"
kubectl exec -it -n istio-system $(kubectl -n istio-system get pods -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -- ls -al /etc/istio/ingressgateway-bookinfo-certs
```

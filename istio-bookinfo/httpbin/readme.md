# 说明

service entry 是将 istio mesh 外部的服务纳管到内部来管理

示例中创建了一个创建一个 ServiceEntry，指向 httpbin.org

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: httpbin-ext
spec:
  hosts:
  - httpbin.org
  ports:
  - number: 80
    name: http
    protocol: HTTP
  resolution: DNS
```

创建一个测试 pod, 用于访问 httpbin.org, 如：nginx

```bash
# time curl -sSL http://httpbin.org/delay/5
{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept": "*/*",
    "Content-Length": "0",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.78.0",
    "X-Amzn-Trace-Id": "Root=1-611c6ceb-168d1321565e06326c876dc8",
    "X-B3-Sampled": "1",
    "X-B3-Spanid": "74763e13ab9d51a8",
    "X-B3-Traceid": "521fc846f65722b374763e13ab9d51a8",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-Decorator-Operation": "httpbin.org:80/*",
    "X-Envoy-Peer-Metadata": "ChkKDkFQUF9DT05UQUlORVJTEgcaBW5naW54ChoKCkNMVVNURVJfSUQSDBoKS3ViZXJuZXRlcwoYCg1JU1RJT19WRVJTSU9OEgcaBTEuOS43CuwBCgZMQUJFTFMS4QEq3gEKDgoDYXBwEgcaBW5naW54ChkKDGlzdGlvLmlvL3JldhIJGgdkZWZhdWx0CiEKEXBvZC10ZW1wbGF0ZS1oYXNoEgwaCjU2NGRmNWY5OGIKJAoZc2VjdXJpdHkuaXN0aW8uaW8vdGxzTW9kZRIHGgVpc3RpbwoqCh9zZXJ2aWNlLmlzdGlvLmlvL2Nhbm9uaWNhbC1uYW1lEgcaBW5naW54CisKI3NlcnZpY2UuaXN0aW8uaW8vY2Fub25pY2FsLXJldmlzaW9uEgQaAnYxCg8KB3ZlcnNpb24SBBoCdjEKGgoHTUVTSF9JRBIPGg1jbHVzdGVyLmxvY2FsCiMKBE5BTUUSGxoZbmdpbngtdjEtNTY0ZGY1Zjk4Yi10OHc2cgoUCglOQU1FU1BBQ0USBxoFbmdpbngKSgoFT1dORVISQRo/a3ViZXJuZXRlczovL2FwaXMvYXBwcy92MS9uYW1lc3BhY2VzL25naW54L2RlcGxveW1lbnRzL25naW54LXYxChcKEVBMQVRGT1JNX01FVEFEQVRBEgIqAAobCg1XT1JLTE9BRF9OQU1FEgoaCG5naW54LXYx",
    "X-Envoy-Peer-Metadata-Id": "sidecar~172.30.0.130~nginx-v1-564df5f98b-t8w6r.nginx~nginx.svc.cluster.local"
  },
  "origin": "117.61.247.88",
  "url": "http://httpbin.org/delay/5"
}
real	0m 6.08s
user	0m 0.00s
sys	0m 0.00s
# time curl -sSL http://httpbin.org/ip
{
  "origin": "117.61.247.88"
}
real	0m 0.83s
user	0m 0.00s
sys	0m 0.00s
```

以上是没有添加任何访问控制的测试，相当于直接访问 httpbin.org.

现在创建一个 virtualservice 来进行控制，比如添加 3s 超时，如下:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: httpbin-service
spec:
  hosts:
  - httpbin.org
  http:
  - timeout: 3s
    route:
    - destination:
        host: httpbin.org
```

此时再去访问，

```bash
# time curl -sSL http://httpbin.org/delay/5
upstream request timeoutreal	0m 3.17s
user	0m 0.00s
sys	0m 0.00s
```

可以看到 5s 的延迟，结果因为限制了超时 3s，在 3s 左右就超时返回了。

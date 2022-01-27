# 说明

安装 istio, 下载安装包，直接使用命令安装即可：

```bash
istioctl install --set profile=default
```

profile 配置文件说明：

- default：根据 IstioOperator API 的默认设置启动组件。 建议用于生产部署和 Multicluster Mesh 中的 Primary Cluster。可以运行 istioctl profile dump 命令来查看默认设置。
- demo：这一配置具有适度的资源需求，旨在展示 Istio 的功能。 它适合运行 Bookinfo 应用程序和相关任务。 这是通过快速开始指导安装的配置。此配置文件启用了高级别的追踪和访问日志，因此不适合进行性能测试。
- minimal：与默认配置文件相同，但只安装了控制平面组件。 它允许您使用 Separate Profile 配置控制平面和数据平面组件(例如 Gateway)。
- remote：配置 Multicluster Mesh 的 Remote Cluster。
- empty：不部署任何东西。可以作为自定义配置的基本配置文件。
- preview：预览文件包含的功能都是实验性。这是为了探索 Istio 的新功能。不确保稳定性、安全性和性能（使用风险需自负）。

各 profile 会安装:

| 核心组件             | default | demo  | minimal | remote | empty | preview |
| :------------------- | :-----: | :---: | :-----: | :----: | :---: | :-----: |
| istio-egressgateway  |         |   ✔   |         |        |       |         |
| istio-ingressgateway |    ✔    |   ✔   |         |        |       |    ✔    |
| istiod               |    ✔    |   ✔   |    ✔    |        |       |    ✔    |

default 和 demo 的配置文件默认情况下启用了自动双向TLS.

安装依赖镜像：

- istio/proxyv2:1.9.7
- istio/pilot:1.9.7

## 虚拟服务

虚拟服务：

- hosts字段列出了virtual service的主机，即用户可寻址的目标或路由规则应用的目标。**它是客户端向服务发送请求时使用的一个或多个地址**，通过该字段提供的地址访问virtual service，进而访问后端服务。在集群内部(网格内)使用时通常与kubernetes的Service同命；当需要在集群外部(网格外)访问时，该字段为gateway请求的地址，即与gateway的hosts字段相同，也可采用DNS的模糊匹配。
- virtual service的主机名可以是IP地址、DNS名称，也可以是短名称(例如Kubernetes服务短名称)，该名称会被隐式或显式解析为全限定域名（FQDN），具体取决于istio依赖的平台。可以使用前缀通配符（“*”）为所有匹配的服务创建一组路由规则。virtual service的hosts不一定是Istio服务注册表的一部分，它们只是**虚拟目的地**，允许用户为网格无法路由到的虚拟主机建立流量模型。
- virtual service的hosts短域名在解析为完整的域名时，补齐的namespace是VirtualService所在的命名空间，而非Service所在的命名空间。如上例的hosts会被解析为：reviews.default.svc.cluster.local。

## 目标规则

- 路由的destination字段指定了匹配条件的流量的实际地址。与virtual service的主机不同，该host**必须是存在于istio的服务注册表(如kubernetes services，consul services等)中的真实目的地或由ServiceEntries声明的hosts**，否则Envoy不知道应该将流量发送到哪里。它可以是一个带代理的网格服务或使用service entry添加的非网格服务。在kubernetes作为平台的情况下，host表示名为kubernetes的service名称.
- 当使用kubernetes的短名称作为destination的主机这种规则时，istio会根据包含路由规则的**virtual service所在的命名空间添加域后缀**，使用短名称意味着可以在任意命名空间中应用这些规则(仅需简单拷贝即可)。Istio根据包含路由规则的虚拟服务的命名空间添加域后缀来获取主机的完整的名称。
- 只有当destination主机和virtual service在相同的kubernetes命名空间下面才会正常工作。由于kubernetes的短名称可能会导致误解，因此建议在生成环境中使用完整的主机名。

## 配置说明

- gateway host 要与 virtualservice 保持一致
- virtualservice 的 destination 中的 host subset 决定访问关系

```bash
istioctl analyze -n bookinfo
kubectl get po -n bookinfo
istioctl proxy-config routes -n bookinfo reviews-v1-6bd74cfcc4-j2jnx --name 9080 -o json
istioctl proxy-config listeners -n bookinfo reviews-v1-6bd74cfcc4-j2jnx
```

## 配置清单准备

- productpage:  这个微服务会调用 details 和 reviews 两个微服务，用来生成页面。
- details: 这个微服务中包含了书籍的信息
- reviews: 这个微服务中包含了书籍相关的评论。它还会调用 ratings 微服务。
- ratings: 这个微服务中包含了由书籍评价组成的评级信息。

## 创建 namespace

```bash
kubectl label namespaces bookinfo istio-injection=enabled
```

# 说明

在使用 Docker 的时候一般情况下我们都会直接使用 docker build 来构建镜像，切换到 Containerd 的时候，可以使用 nerdctl + buildkit 来构建容器镜像，除了这些方式之外，还有使用 dind 方式也可以实现。

以 daemonSet 方式部署 dind 后，k8s 节点上所有主机将会安装 docker 客户端，并且在各个宿主机上在 pod 内启动了一个 docked, 同时 socket 文件挂载到宿主机，从而在宿主机上可以使用 docker 客户端命令来做镜像构建等操作。docker 镜像等数据通过 pvc 挂载到外部存储，下载的镜像不会丢失。

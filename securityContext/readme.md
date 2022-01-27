# Pod 安全性标准

[Pod 安全性标准 | Kubernetes](https://kubernetes.io/zh/docs/concepts/security/pod-security-standards/)

[Docker run reference | Docker Documentation](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)

[Kuboard中容器的Security Context | Kuboard](https://kuboard.cn/learning/k8s-intermediate/config/sec-ctx/con-kuboard.html)

[你应该了解的10个 Kubernetes 安全上下文设置[译]-阳明的博客|Kubernetes|Istio|Prometheus|Python|Golang|云原生](https://www.qikqiak.com/post/k8s-10-secruity-context-settings/)

[Kubernetes 最佳安全实践指南 - 云+社区 - 腾讯云](https://cloud.tencent.com/developer/article/1759969)

[Kubernetes SecurityContext安全上下文_地下库-CSDN博客](https://blog.csdn.net/xixihahalelehehe/article/details/108539153)

[容器 Security Context (安全上下文) | iBlog](https://luckymrwang.github.io/2020/12/04/Security%20Context%20(%E5%AE%89%E5%85%A8%E4%B8%8A%E4%B8%8B%E6%96%87)/)

[kubernetes高级之pod安全策略 - 周国通 - 博客园](https://www.cnblogs.com/tylerzhou/p/11078128.html)

[在 Kubernetes 中配置 Container Capabilities-阳明的博客|Kubernetes|Istio|Prometheus|Python|Golang|云原生](https://www.qikqiak.com/post/capabilities-on-k8s/)

AllowPrivilegeEscalation: 控制一个进程是否能比其父进程获取更多的权限，AllowPrivilegeEscalation的值是bool值，如果一个容器以privileged权限运行或具有CAP_SYS_ADMIN权限，则AllowPrivilegeEscalation的值将总是true。

注意：要开启容器的privileged权限，需要提前在kube-apiserver和kubelet启动时添加参数--allow-privileged=true，默认已添加。

实际上这是配置对应的容器的 Capabilities，在我们使用 docker run 的时候可以通过 --cap-add 和 --cap-drop 命令来给容器添加 Linux Capabilities。

注意事项：

- dockerfile 中需要指定相应的用户（9001）和组（9001）
- gosu 在 k8s 中其实没有太大必要使用

## 应用停止后 dump heap

-XX:+HeapDumpOnCtrlBreak

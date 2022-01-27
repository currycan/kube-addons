# 调优

[k8s安装前系统优化脚本 – 刘洋的小站](http://www.wmmzz.com/k8sanzhuangqianxitongyouhuajiaoben/)

[Kubernetes 调优 | Rancher文档](https://docs.rancher.cn/docs/rancher2/best-practices/optimize/kubernetes/_index/)

[提前预防K8s集群资源不足的处理方式配置 - KubeSphere 开发者社区](https://kubesphere.com.cn/forum/d/1155-k8s)

[JVM在k8s中参数调整 - 掘金](https://juejin.cn/post/6844903952689922062)

[kubernetes 实用技巧: 为 Pod 设置内核参数 | roc云原生](https://imroc.cc/post/202105/set-sysctl/)

[CoreDNS 性能优化 | kubernetes 学习笔记](https://imroc.cc/k8s/best-practice/optimize-dns/)

[使用Descheduler组件对Pod进行调度优化](https://help.aliyun.com/document_detail/206419.html)

[最佳实践 - 大规模集群优化 - 《Kubernetes 实践指南（Kubernetes Practice Guide）》 - 书栈网 · BookStack](https://www.bookstack.cn/read/kubernetes-practice-guide/best-practice-big-cluster.md)

[使用 Kube-Vip 部署 高可用的 Kubernetes 集群 - 「Yang'zun」PlayGround](https://www.treesir.pub/post/kube-vip-deploy-ha-k8s-cluster/)

问题 1
JDK 8u191 之前这个问题很常见，主要是由于 JVM 获得的最大内存是主机的最大内存而不是容器的最大可用内存，解决方法是修改启动逻辑。
让 JVM 能够获取到正确的最大可用内存

问题 2
ParallelGC 线程数如果过高会导致 GC 过于频繁，和问题1 类似，这是由于 JVM 获得的可用核数不正确导致的。

为了解决这两个需要同时修改容器的资源限制和 JVM 的启动参数，并使之相匹配。
当然也有一种不那么笨的做法是引入一个动态的启动脚本，先根据容器的实际资源限制算出对应的 JVM 参数再去启动 JVM。
JDK 社区已经注意到以上这几个容器化常遇到的问题并在新的 JDK 版本里解决了

```bash
java -XshowSettings:vm -version
java -XX:MaxRAMPercentage=100.0 -XshowSettings:vm -version
java -XX:InitialRAMPercentage=50.0 -XshowSettings:vm -version
java -XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=100.0 -XshowSettings:vm -version
java -XX:InitialRAMPercentage=100.0 -XX:MaxRAMPercentage=100.0 -XshowSettings:vm -version
java -XX:InitialRAMPercentage=20.0 -XX:MaxRAMPercentage=75.0 -XX:MinRAMPercentage=55.0 -XshowSettings:vm -version

java -XX:MaxRAMPercentage=85.0 -XX:MinRAMPercentage=40.0 -XX:InitialRAMPercentage=20.0 -XX:-UseAdaptiveSizePolicy -XX:+UseContainerSupport -XshowSettings:vm -version

java -XshowSettings:vm -version -XX:InitiatingHeapOccupancyPercent=40 -XX:MaxRAMPercentage=80.0 -XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=40.0 -XX:+UseContainerSupport
```

java -XshowSettings:vm -Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m -XX:MetaspaceSize=256m -XX:MaxDirectMemorySize=256m -XX:MaxRAMPercentage=80.0 -XX:InitialRAMPercentage=40.0 -XX:MinRAMPercentage=50.0 -XX:+UseContainerSupport -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -version

- 默认的最大堆大小是物理内存的一半
- 堆大小与 -XX:InitialRAMPercentage -XX:MaxRAMPercentage -XX:MinRAMPercentage 三个参数相关，取值是按资源的 **limit** 来计算
- 最终决定能使用的大小是由 -XX:MaxRAMPercentage -XX:MinRAMPercentage 决定，哪个最大取哪个
- 一旦配置了-Xmx -XX:MaxRAMPercentage 参数失效，同理配置了 -Xms，-XX:MinRAMPercentage 参数失效
- -XX:+UseAdaptiveSizePolicy 自动调整堆大小
- 如果整个物理服务器（或容器）的内存大小超过250MB，则不必配置"-XX:MinRAMPercentage"，仅配置"-XX:MaxRAMPercentage"就足够了。大多数企业级Java应用程序将以超过250MB的速度运行（除非您正在用Java构建IoT或网络设备应用程序）。
- -XX:InitiatingHeapOccupancyPercent=40,当堆空间的占用率达到一定阈值后会触发Old GC,默认值：45

查看 jvm 内存信息：

```bash
$ jps
$ jinfo -flags 18
$ java -XshowSettings:vm -version -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:InitiatingHeapOccupancyPercent=40 -XX:+ParallelRefProcEnabled -XX:MaxRAMPercentage=80.0 -XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=40.0 -XX:+UseContainerSupport -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -Xloggc:/jvm/logs/gc-%t.log -XX:ErrorFile=/jvm/logs/hs_err_%p.log -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCApplicationConcurrentTime -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintClassHistogramBeforeFullGC -XX:+PrintClassHistogramAfterFullGC -XX:HeapDumpPath=/jvm/logs/
$ jmap -heap 18
Attaching to process ID 19, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 25.201-b09

using thread-local object allocation.
Garbage-First (G1) GC with 1 thread(s)

Heap Configuration:
   MinHeapFreeRatio         = 40
   MaxHeapFreeRatio         = 70
   MaxHeapSize              = 109051904 (104.0MB)
   NewSize                  = 1363144 (1.2999954223632812MB)
   MaxNewSize               = 65011712 (62.0MB)
   OldSize                  = 5452592 (5.1999969482421875MB)
   NewRatio                 = 2
   SurvivorRatio            = 8
   MetaspaceSize            = 21807104 (20.796875MB)
   CompressedClassSpaceSize = 1073741824 (1024.0MB)
   MaxMetaspaceSize         = 17592186044415 MB
   G1HeapRegionSize         = 1048576 (1.0MB)

Heap Usage:
G1 Heap:
   regions  = 104
   capacity = 109051904 (104.0MB)
   used     = 51904504 (49.49999237060547MB)
   free     = 57147400 (54.50000762939453MB)
   47.59614651019756% used
G1 Young Generation:
Eden Space:
   regions  = 23
   capacity = 63963136 (61.0MB)
   used     = 24117248 (23.0MB)
   free     = 39845888 (38.0MB)
   37.704918032786885% used
Survivor Space:
   regions  = 5
   capacity = 5242880 (5.0MB)
   used     = 5242880 (5.0MB)
   free     = 0 (0.0MB)
   100.0% used
G1 Old Generation:
   regions  = 22
   capacity = 39845888 (38.0MB)
   used     = 22544376 (21.49999237060547MB)
   free     = 17301512 (16.50000762939453MB)
   56.578927291067025% used

16848 interned Strings occupying 1576376 bytes.
```

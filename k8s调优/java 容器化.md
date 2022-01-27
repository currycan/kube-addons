# 容器化

[JVM 对容器化支持的参数 | 龙天的博客](https://blog.longtian.info/2021/04/13/containerized-jvm-parameters.html)

[JAVA 应用在Kubernetes下的内存限制 - 知乎](https://zhuanlan.zhihu.com/p/370241822)

[容器中的JVM资源该如何被安全的限制？_Kubernetes中文社区](https://www.kubernetes.org.cn/5005.html)

[K8S(18)容器环境下资源限制与jvm内存回收 - noah-罗 - 博客园](https://www.cnblogs.com/noah-luo/p/14721172.html)

[容器环境的JVM内存设置最佳实践 - JadePeng - 博客园](https://www.cnblogs.com/xiaoqi/p/container-jvm.html)

[用了3年Kubernetes，我们得到的5个教训 - 云+社区 - 腾讯云](https://cloud.tencent.com/developer/article/1728632)

[Java服务启动慢，JVM预热的问题，我在k8s上改进了_朱小厮的博客-CSDN博客](https://blog.csdn.net/u013256816/article/details/116868436)

注意，在8u191版本后，-XX:{Min|Max}RAMFraction 被弃用，引入了-XX:MaxRAMPercentage，其值介于0.0到100.0之间，默认值为25.0。

较高版本Java9之后（8u131+）JVM提供更好的解决方式

      使用JVM 标志： -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap

强制JVM检查Linux的cgoup配置，实际上docker正是通过Linux的cgroup技术来限制容器的内存等资源的。现在如果应用达到了docker设置的限制（比如1G）,JVM是可以看到这个限制的，JVM就会尝试GC操作。

早期时候，容器内运行Java应用程序时，Jvm无法感知容器环境存在，所以对容器资源的限制比如内存或者cpu等都无法生效。原因是容器的资源管理使用了操作系统cgroup机制，但是Jvm无法感知cgroup。所以可能需要在jvm以及docker中指定两次内存限制。后来，在Jvm9及以后，Jvm开始了对容器资源限制的支持。在Jvm11中，可以使用-XX:+UseContainerSupport参数来制定Jvm使用容器内存。另外还有两个参数-XX:InitialRAMPercentage -XX:MaxRAMPercentage来制定Jvm使用容器内存的百分比。

JVM内存  = heap 内存 + 线程stack内存 (XSS) * 线程数 + 启动开销（constant overhead）

-Xmx2048m -Xms2048m -Djava.security.egd=file:/dev/./urandom -XX:ErrorFile=/opt/soft/logs/evidence/hs_err_%p.log -Xloggc:/opt/soft/logs/evidence/gc_%p.log -XX:HeapDumpPath=/opt/soft/logs/evidence/ -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintClassHistogramBeforeFullGC -XX:+PrintClassHistogramAfterFullGC -XX:+PrintGCApplicationConcurrentTime -XX:+PrintGCApplicationStoppedTime -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap

-server -Xms4g -Xmx4g -XX:MaxMetaspaceSize=256m -XX:MetaspaceSize=256m -XX:MaxDirectMemorySize=256m  -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:InitiatingHeapOccupancyPercent=40 -XX:+ParallelRefProcEnabled -agentlib:jdwp=transport=dt_socket,address=2020,server=y,suspend=n -XX:ErrorFile=/opt/logs/oom/hs_err_pid%p.log   -Xloggc:/opt/logs/oom/gc.log -XX:HeapDumpPath=/opt/data/heapdump.hprof -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintClassHistogramBeforeFullGC -XX:+PrintClassHistogramAfterFullGC -XX:+PrintGCApplicationConcurrentTime -XX:+PrintGCApplicationStoppedTime -XX:+PrintHeapAtGC

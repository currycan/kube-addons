# FROM currycan/oracle-jdk:8u201
FROM currycan/oracle-jdk:8u201-alpine

ENV WORKDIR /app
WORKDIR ${WORKDIR}

ENV JAR_FILE=app.jar
ADD --chown=${uid}:${gid} *.jar ${WORKDIR}/${JAR_FILE}

ENV APP_OPTS=""
ENV JVM_LOGS="/jvm/logs"
ENV MY_CPU_LIMIT="1"
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxGCPauseMillis=150 -XX:InitiatingHeapOccupancyPercent=40 -XX:ActiveProcessorCount=${MY_CPU_LIMIT} -XX:+ParallelRefProcEnabled"
# JDK8u191后加入了UseContainerSupport、MaxRAMPercentage、MinRAMPercentage、InitialRAMPercentage参数。deprecate了UseCGroupMemoryLimitForHeap、MaxRAMFraction、MinRAMFraction、InitialRAMFraction参数。
# https://help.aliyun.com/document_detail/383255.html
# https://help.aliyun.com/document_detail/98492.html
ENV JVM_ARGS="-XX:+UseContainerSupport -XX:-UseAdaptiveSizePolicy -XX:+UnlockExperimentalVMOptions -XX:InitialRAMPercentage=60.0 -XX:MaxRAMPercentage=60.0 -XX:MinRAMPercentage=25.0"
ENV JVM_GC="-XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=100M -XX:+PrintCommandLineFlags -Xloggc:${JVM_LOGS}/gc-%t.log -XX:ErrorFile=${JVM_LOGS}/hs_err_%p.log -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCApplicationConcurrentTime -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintClassHistogramBeforeFullGC -XX:+PrintClassHistogramAfterFullGC -XX:HeapDumpPath=${JVM_LOGS}"

COPY run.sh /run.sh

ENTRYPOINT [ "/run.sh"]

CMD [ "--file.path=/app/logs/app-demo/info.log" ]

# FROM currycan/oracle-jdk:8u201
FROM currycan/oracle-jdk:8u201-alpine

ENV JVM_LOGS /jvm/logs

# -Xms4g -Xmx4g -XX:MaxMetaspaceSize=256m -XX:MetaspaceSize=256m -XX:MaxDirectMemorySize=256m
ENV APP_OPTS=""
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:InitiatingHeapOccupancyPercent=45.0 -XX:ActiveProcessorCount=$MY_CPU_LIMIT -XX:+ParallelRefProcEnabled"
# java 191 以上版本支持,-XX:+UseCGroupMemoryLimitForHeap放弃使用，-XX:+UseContainerSupport 默认支持
ENV JVM_ARGS="-XX:MaxRAMPercentage=75.0 -XX:MinRAMPercentage=25.0 -XX:InitialRAMPercentage=40.0 -XX:-UseAdaptiveSizePolicy -XX:+UnlockExperimentalVMOptions"
ENV JVM_GC="-XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -XX:+PrintReferenceGC -Xlog:os+container=logLevel -XX:+PrintSafepointStatistics -XX:PrintSafepointStatisticsCount=1 -Xloggc:${JVM_LOGS}/gc-%t.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M -XX:ErrorFile=${JVM_LOGS}/hs_err_%p.log -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCApplicationConcurrentTime -XX:+PrintClassHistogramBeforeFullGC -XX:+PrintClassHistogramAfterFullGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${JVM_LOGS}"

ENV WORKDIR /app
WORKDIR ${WORKDIR}

ENV JAR_FILE=app.jar
ADD --chown=${uid}:${gid} *.jar ${WORKDIR}/${JAR_FILE}

COPY run.sh /run.sh
RUN set -ex; \
  chmod 755 /run.sh; \
  mkdir -p ${JVM_LOGS}; \
  chown -R ${uid}:${gid} ${JVM_LOGS} ${WORKDIR}

VOLUME [ "${JVM_LOGS}" ]

ENTRYPOINT [ "/run.sh"]

CMD [ "--file.path=/app/logs/app-demo/info.log" ]

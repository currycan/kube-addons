FROM currycan/oracle-jdk:8u201
# FROM currycan/oracle-jdk:8u201-alpine

ENV WORKDIR /app
WORKDIR ${WORKDIR}

ENV JAR_FILE=app.jar
ADD --chown=${uid}:${gid} *.jar ${WORKDIR}/${JAR_FILE}

COPY run.sh /run.sh

ENTRYPOINT [ "/run.sh"]

CMD [ "--file.path=/app/logs/app-demo/info.log" ]

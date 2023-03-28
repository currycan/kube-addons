FROM alpine:3

LABEL maintainer="andrew <ansandy@foxmail.com>"

# Java Version and other ENV
ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_MINOR=201
ARG JAVA_VERSION_BUILD=09
ARG JAVA_PACKAGE=jdk
# ARG JAVA_JCE=standard
ARG JAVA_JCE=unlimited
ENV JAVA_HOME=/opt/jdk
ENV PATH=${PATH}:/opt/jdk/bin
ENV LANG=C.UTF-8
# install jdk8
RUN set -ex; \
  [[ ${JAVA_VERSION_MAJOR} != 7 ]] || ( echo >&2 'Oracle no longer publishes JAVA7 packages' && exit 1 ); \
  apk add --update --no-cache --virtual .build-deps \
    curl \
    ca-certificates; \
  curl -jkSLo /tmp/java.tar.gz \
    "https://mirrors.huaweicloud.com/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz"; \
  JAVA_PACKAGE_SHA256=$(curl -sSL https://www.oracle.com/webfolder/s/digest/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}checksum.html | grep -E "${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64\.tar\.gz" | grep -Eo '(sha256: )[^<]+' | cut -d: -f2 | xargs); \
  echo "${JAVA_PACKAGE_SHA256}  /tmp/java.tar.gz" > /tmp/java.tar.gz.sha256; \
  sha256sum -c /tmp/java.tar.gz.sha256; \
  gunzip /tmp/java.tar.gz; \
  tar -C /opt -xf /tmp/java.tar; \
  ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME}; \
  ln -s "$JAVA_HOME/bin/"* "/usr/bin/"; \
  if [ "${JAVA_JCE}" == "unlimited" ]; then echo "Installing Unlimited JCE policy" >&2; \
    curl -jkSLo /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip -b "oraclelicense=a" \
      http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip ; \
    cd /tmp && unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip; \
    cp -v /tmp/Unlimited**/*.jar ${JAVA_HOME}/jre/lib/security; \
  fi; \
  sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/jre/lib/security/java.security; \
  echo "securerandom.source=file:/dev/urandom" >> $JAVA_HOME/jre/lib/security/java.security; \
  sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/jre/lib/security/java.security; \
  rm -rf ${JAVA_HOME}/*src.zip \
    ${JAVA_HOME}/lib/missioncontrol \
    ${JAVA_HOME}/lib/visualvm \
    ${JAVA_HOME}/lib/*javafx* \
    ${JAVA_HOME}/jre/plugin \
    ${JAVA_HOME}/jre/bin/javaws \
    ${JAVA_HOME}/jre/bin/jjs \
    ${JAVA_HOME}/jre/bin/orbd \
    ${JAVA_HOME}/jre/bin/pack200 \
    ${JAVA_HOME}/jre/bin/policytool \
    ${JAVA_HOME}/jre/bin/rmid \
    ${JAVA_HOME}/jre/bin/rmiregistry \
    ${JAVA_HOME}/jre/bin/servertool \
    ${JAVA_HOME}/jre/bin/tnameserv \
    ${JAVA_HOME}/jre/bin/unpack200 \
    ${JAVA_HOME}/jre/lib/javaws.jar \
    ${JAVA_HOME}/jre/lib/deploy* \
    ${JAVA_HOME}/jre/lib/desktop \
    ${JAVA_HOME}/jre/lib/*javafx* \
    ${JAVA_HOME}/jre/lib/*jfx* \
    ${JAVA_HOME}/jre/lib/amd64/libdecora_sse.so \
    ${JAVA_HOME}/jre/lib/amd64/libprism_*.so \
    ${JAVA_HOME}/jre/lib/amd64/libfxplugins.so \
    ${JAVA_HOME}/jre/lib/amd64/libglass.so \
    ${JAVA_HOME}/jre/lib/amd64/libgstreamer-lite.so \
    ${JAVA_HOME}/jre/lib/amd64/libjavafx*.so \
    ${JAVA_HOME}/jre/lib/amd64/libjfx*.so \
    ${JAVA_HOME}/jre/lib/ext/jfxrt.jar \
    ${JAVA_HOME}/jre/lib/ext/nashorn.jar \
    ${JAVA_HOME}/lib/oblique-fonts \
    ${JAVA_HOME}/lib/plugin.jar \
    ${JAVA_HOME}/*.txt; \
  apk del --no-network .build-deps; \
  rm -rf /tmp/* /var/cache/apk/*; \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf;

ENV TZ=Asia/Shanghai
RUN set -ex; apk -U upgrade; apk add --update --no-cache \
    bash \
    tzdata \
    curl \
    su-exec \
    tini; \
  ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime; \
  echo ${TZ} > /etc/timezone; \
  rm -rf /var/cache/apk/*

# glibc
ENV GLIBC_VERSION=2.35-r0
RUN set -ex; \
  apk add --update --no-cache libstdc++; \
  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
  for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; \
  do \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; \
  done; \
  apk add /tmp/*.apk; \
  ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ); \
  echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh; \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib; \
  apk del --no-network glibc-i18n; \
  rm -rf /tmp/* /var/cache/apk/*

ENV user=normal
ENV group=normal
ENV uid=9001
ENV gid=9001
RUN set -ex; \
  addgroup -S -g ${gid} ${group} && adduser -S -D -G ${group} -u ${uid} ${user} -s /bin/bash; \
  apk add --update --no-cache sudo; \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user}; \
  chmod 0440 /etc/sudoers.d/${user}; \
  echo 'export PS1="\u@\h:\w\$ "' >> ~/.bashrc; \
  cp -a /root/.bashrc /home/${user}/.bashrc; \
  chown -R ${uid}:${gid} /home/${user}/.bashrc; \
  rm -rf /tmp/* /var/cache/apk/*;

ARG VERSION=0.18.0
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${VERSION}/jmx_prometheus_javaagent-${VERSION}.jar /jmx/jmx_prometheus_javaagent.jar
COPY jmx-config.yaml /jmx/
ENV JMX_PORT="18088"
ENV JMX="-javaagent:/jmx/jmx_prometheus_javaagent.jar=${JMX_PORT}:/jmx/jmx-config.yaml "

CMD [ "/bin/bash" ]

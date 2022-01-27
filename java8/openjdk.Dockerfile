FROM centos:7.7.1908

LABEL maintainer="zhangzhitao <zhangzhitao@lakala.com>"

ENV JAVA_VERSION=1.8.0 \
    JAVA_UPDATE=232 \
    JAVA_BUILD=09 \
    JAVA_HOME=/etc/alternatives/jre

RUN set -ex; \
  yum install -y \
    java-1.8.0-openjdk-${JAVA_VERSION}.${JAVA_UPDATE}.b${JAVA_BUILD}-0.el7_7 \
    java-1.8.0-openjdk-devel--${JAVA_VERSION}.${JAVA_UPDATE}.b${JAVA_BUILD}-0.el7_7 \
    gettext \
    kde-l10n-Chinese; \
  yum reinstall -y glibc-common; \
  localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
  echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/jre/lib/security/java.security; \
  yum clean all; \
  rm -rf /var/cache/yum/*

ENV TZ=Asia/Shanghai  LC_ALL=zh_CN.utf8

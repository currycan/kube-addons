FROM centos:7

LABEL maintainer="currycan <ansandyzzt@gmail.com>"

RUN set -ex; \
  yum update -y; \
  yum install -y \
  unzip \
  gettext \
  net-tools \
  telnet \
  iproute \
  bash-completion \
  kde-l10n-Chinese; \
  yum reinstall -y glibc-common; \
  localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
  yum clean all; \
  rm -rf /tmp/*; \
  rm -rf /var/cache/yum/*

ENV TZ=Asia/Shanghai LANG=zh_CN.utf8

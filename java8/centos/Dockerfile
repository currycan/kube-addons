FROM currycan/centos:7

# Java Version and other ENV
ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_MINOR=201
ARG JAVA_VERSION_BUILD=09
ARG JAVA_PACKAGE=jdk
# ARG JAVA_JCE=standard
ARG JAVA_JCE=unlimited
ENV JAVA_HOME=/opt/jdk
ENV PATH=${PATH}:/opt/jdk/bin

RUN set -ex; \
  [[ ${JAVA_VERSION_MAJOR} != 7 ]] || ( echo >&2 'Oracle no longer publishes JAVA7 packages' && exit 1 ); \
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
  update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 999999; \
  update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 999999; \
  rm -rf /tmp/*; \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

ENV user=normal
ENV group=normal
ENV uid=9001
ENV gid=9001
# Java application run with user `normal`, uid = 9001
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN set -ex; \
  yum install -y sudo; \
  echo "${user} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${user}; \
  chmod 0440 /etc/sudoers.d/${user}; \
  yum clean all; \
  rm -rf /tmp/*; \
  rm -rf /var/cache/yum/*; \
  groupadd -r -g ${gid} ${group} && useradd -u ${uid} -g ${gid} -m -r -s /bin/bash ${user}; \
  cp -a /root/.bashrc /home/${user}/.bashrc; \
  chown -R ${uid}:${gid} /home/${user}/.bashrc

ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd
# Use tini as subreaper in Docker container to adopt zombie processes
RUN set -ex; \
  curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini; \
  chmod 755 /bin/tini; \
  echo "$TINI_SHA  /bin/tini" | sha256sum -c -

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.14
RUN set -ex; \
  curl -sSLo /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64"; \
  curl -sSLo /usr/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc"; \
  export GNUPGHOME="$(mktemp -d)"; \
  gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
  gpg --batch --verify /usr/bin/gosu.asc /usr/bin/gosu; \
  rm -rf "$GNUPGHOME" /usr/bin/gosu.asc /root/.gnupg/; \
  chmod 755 /usr/bin/gosu; \
  gosu nobody true

# USER ${user}

CMD [ "/bin/bash" ]

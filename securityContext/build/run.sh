#! /bin/bash -e

set -eou pipefail

#检查系统
check_sys(){
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "Alpine"; then
        release="alpine"
    fi
}

if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
    check_sys
    # run as root
    if [ "$(id -u)" = '0' ]; then
        find ${JVM_LOGS} \! -user ${user} -exec chown ${user} '{}' +
        find . \! -user ${user} -exec chown ${user} '{}' +
        if [[ "${release}" == "centos" ]]; then
            exec /bin/tini /usr/bin/gosu ${user} -- java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        elif [[ "${release}" == "alpine" ]]; then
            exec /sbin/tini /sbin/su-exec ${user} java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        fi
    # run as non-root
    else
        if [[ "${release}" == "centos" ]]; then
            exec /bin/tini -- java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        elif [[ "${release}" == "alpine" ]]; then
            exec /sbin/tini java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        fi
    fi
fi

# As argument is not java application, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"

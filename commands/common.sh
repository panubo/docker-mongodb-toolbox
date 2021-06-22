#!/usr/bin/env bash

HOST=${DATABASE_HOST-${MONGODB_PORT_27017_TCP_ADDR-localhost}}
PORT=${DATABASE_PORT-${MONGODB_PORT_27017_TCP_PORT-27017}}
USER=${DATABASE_USER-""}
PASS=${DATABASE_PASS-${MONGODB_ENV_MYSQL_ROOT_PASSWORD}}
# This could be made db specific by using --defaults-file=
# MYCONN="--user=${USER} --password=${PASS} --host=${HOST} --port=${PORT}"
# MYSQL="mysql ${MYCONN}"
# MYSQLDUMP="mysqldump $MYCONN"
# MYCHECK="mysqlcheck ${MYCONN}"
GZIP="gzip --fast"

wait_mongodb() {
    # Wait for MongoDB to be available
    TIMEOUT=${3:-30}
    echo -n "Waiting to connect to MongoDB at ${1-$HOST}:${2-$PORT}"
    for (( i=0;; i++ )); do
        if [ ${i} -eq ${TIMEOUT} ]; then
            echo " timeout!"
            exit 99
        fi
        sleep 1
        (exec 3<>/dev/tcp/${1-$HOST}/${2-$PORT}) &>/dev/null && break
        echo -n "."
    done
    echo " connected."
    exec 3>&-
    exec 3<&-
}

genpasswd() {
  # Ambiguous characters have been been excluded
  CHARS="abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ"

  export LC_CTYPE=C  # Quiet tr warnings
  local length
  length="${1:-16}"
  set +o pipefail
  strings < /dev/urandom | tr -dc "${CHARS}" | head -c "${length}" | xargs
  set -o pipefail
}

echoerr() { echo "$@" 1>&2; }

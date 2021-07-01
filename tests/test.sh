#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

CWD="$(dirname $0)/"

. ${CWD}functions.sh

echo "=> Test save command"
docker run -d --name mongodb -p 27017:27017 ${MONGODB_IMAGE}:${MONGODB_TAG} > /dev/null
docker run -d --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
docker run -t -i --name $TEST_NAME --link mongodb -e DATA_DIR=/data $TEST_CONTAINER save
cleanup mongodb minio $TEST_NAME

echo "=> Test load command"
TMPDIR="/tmp/data.$$"
mkdir -p ${TMPDIR}
docker run -d --name mongodb -p 27017:27017 ${MONGODB_IMAGE}:${MONGODB_TAG} > /dev/null
docker run -d --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
docker run -t -i --name ${TEST_NAME}-save --link mongodb -v ${TMPDIR}:/data -e DATA_DIR=/data $TEST_CONTAINER save
docker run -t -i --name ${TEST_NAME}-load --link mongodb -v ${TMPDIR}:/data -e DATA_DIR=/data $TEST_CONTAINER load
cleanup mongodb minio ${TEST_NAME}-save ${TEST_NAME}-load
rm -rf ${TMPDIR}
echo "=> Done"

#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

CWD="$(dirname $0)/"

. ${CWD}functions.sh

echo "=> Test load command"
docker run -d --name mongodb -p 27017:27017 ${MONGODB_IMAGE}:${MONGODB_TAG} > /dev/null
docker run -d --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
cleanup mongodb minio $TEST_NAME

echo "=> Test save command"
docker run -d --name mongodb -p 27017:27017 ${MONGODB_IMAGE}:${MONGODB_TAG} > /dev/null
docker run -d --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
cleanup mongodb minio $TEST_NAME

echo "=> Done"

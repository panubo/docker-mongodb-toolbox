#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

CWD="$(dirname $0)/"

. ${CWD}functions.sh

echo "=> Test save command"
docker run -d --name mongodb -p 27017:27017 ${MONGODB_IMAGE}:${MONGODB_TAG} > /dev/null
docker run -d --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
docker run --rm -ti --link minio -e MC_HOST_minio=http://minioadmin:minioadmin@minio:9000 minio/mc:latest --quiet mb minio/backup
docker run -t -i --name $TEST_NAME --link mongodb --link minio -e AWS_ACCESS_KEY_ID=minioadmin -e AWS_SECRET_ACCESS_KEY=minioadmin -e AWS_S3_ADDITIONAL_ARGS="--endpoint-url http://minio:9000" $TEST_CONTAINER save --host mongodb s3://backup
cleanup mongodb minio $TEST_NAME

echo "=> Test load command"
TMPDIR="/tmp/data.$$"
mkdir -p ${TMPDIR}
docker run -d --name mongodb -p 27017:27017 ${MONGODB_IMAGE}:${MONGODB_TAG} > /dev/null
docker run -d --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
docker run --rm -ti --link minio -e MC_HOST_minio=http://minioadmin:minioadmin@minio:9000 minio/mc:latest --quiet mb minio/backup
docker run -t -i --name ${TEST_NAME}-save --link mongodb --link minio -e AWS_ACCESS_KEY_ID=minioadmin -e AWS_SECRET_ACCESS_KEY=minioadmin -e AWS_S3_ADDITIONAL_ARGS="--endpoint-url http://minio:9000" $TEST_CONTAINER save --host mongodb s3://backup
docker run -t -i --name ${TEST_NAME}-load --link mongodb --link minio -e AWS_ACCESS_KEY_ID=minioadmin -e AWS_SECRET_ACCESS_KEY=minioadmin -e AWS_S3_ADDITIONAL_ARGS="--endpoint-url http://minio:9000" $TEST_CONTAINER load --host mongodb s3://backup local newdb
cleanup mongodb minio ${TEST_NAME}-save ${TEST_NAME}-load
rm -rf ${TMPDIR}
echo "=> Done"

# Testing with cloud atlas with the test dataset loaded
# . cloudatlas.env
# echo "=> Test save command (cloud atlass)"
# docker run -d -v $(pwd)/data:/data --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
# docker run --rm -ti --link minio -e MC_HOST_minio=http://minioadmin:minioadmin@minio:9000 minio/mc:latest --quiet mb minio/backup || true
# docker run -t -i --name $TEST_NAME --link minio -e AWS_ACCESS_KEY_ID=minioadmin -e AWS_SECRET_ACCESS_KEY=minioadmin -e AWS_S3_ADDITIONAL_ARGS="--endpoint-url http://minio:9000" -e SAVE_SKIP_DATABASES="sample_analytics,sample_geospatial,sample_mflix,sample_restaurants,sample_supplies,sample_training,sample_weatherdata,local" $TEST_CONTAINER save --ssl --authenticationDatabase=admin --user admin --password ${MONGO_PASS} --host ${MONGO_HOST} s3://backup
# cleanup minio $TEST_NAME

# echo "=> Test load command (cloud atlass)"
# docker run -d -v $(pwd)/data:/data --name minio -p 9000:9000 ${MINIO_IMAGE}:${MINIO_TAG} server /data > /dev/null
# docker run --rm -ti --link minio -e MC_HOST_minio=http://minioadmin:minioadmin@minio:9000 minio/mc:latest --quiet mb minio/backup || true
# docker run -t -i --name $TEST_NAME --link minio -e AWS_ACCESS_KEY_ID=minioadmin -e AWS_SECRET_ACCESS_KEY=minioadmin -e AWS_S3_ADDITIONAL_ARGS="--endpoint-url http://minio:9000" $TEST_CONTAINER load --ssl --authenticationDatabase admin --username admin --password ${MONGO_PASS} --host ${MONGO_HOST} s3://backup sample_airbnb foo
# cleanup minio $TEST_NAME

#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

CWD="$(dirname $0)/"

. ${CWD}functions.sh

TEST_CONTAINER="dind-runner-$$"
DOCKERFILE="Dockerfile.test"

echo ">> Using Temp Dockerfile: $DOCKERFILE"

cat << EOF > $DOCKERFILE
FROM ${DIND_IMAGE}:${DIND_TAG}
ENV DOCKER_HOST='unix:///var/run/docker.sock'
RUN apk add bash
ADD .  /build/
WORKDIR /build
ENTRYPOINT ["/bin/bash"]
CMD ["/build/tests/runner.sh"]
EOF

echo ">> Building"
docker build -f $DOCKERFILE -t $TEST_CONTAINER .

echo ">> Running"
docker run --platform ${PLATFORM} --privileged -ti --rm $TEST_CONTAINER

echo ">> Removing"
docker rmi $TEST_CONTAINER
rm -f $DOCKERFILE

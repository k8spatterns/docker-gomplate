#!/bin/sh -x
gomplate_version=v1.6.0-x3
repo="k8spatterns/gomplate"
docker build --no-cache --build-arg version=${gomplate_version} -t ${repo}:${gomplate_version} .
docker tag ${repo}:${gomplate_version} ${repo}:latest
if [ "x$1" == "x-p" ]; then
  docker push ${repo}:${gomplate_version}
  docker push ${repo}:latest
fi

#!/bin/bash

sudo podman build --tls-verify=false -t quay.io/robinwu456/bliss_redis .
[ $? != "0" ] && exit 1

sudo podman stop bliss_redis
sudo podman run --rm --name bliss_redis -h bliss_redis -d -p 6379:6379 quay.io/robinwu456/bliss_redis

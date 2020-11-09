#!/bin/bash

set -euo pipefail
set -x

deployed_code="$1"

chmod -R a+rw "$deployed_code"

# Stop previous robot code instance
[ -z "$(docker ps -q --filter "name=robot_code")" ] || docker stop robot_code

# Start new instance
docker run \
	-d \
	--rm \
	--name=robot_code \
	--log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
	--network=container:sim \
	-v "$deployed_code":/home/frc/code \
	localhost:5000/robot_code:latest

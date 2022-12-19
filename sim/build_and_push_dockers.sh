#!/bin/bash

# Run this script on your machine to build and deploy a new version of the simulator to a remote
# simulator VM.
#
# Before running this script, build the simulator in Unity for WebGL and x86-64 server targets.
# The webgl target should be saved into $sim_build_dir with a name of `webgl` and the server
# target should be saved into $sim_build_dir/server with a name of `server`

set -euo pipefail

# A version string to use to tag the new version of the simulator, such as 0.12.1
version=$1
# The directory containing the builds of the Unity simulator project
sim_build_dir=$2

script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

docker build -t team766/2020sim:${version} -f $script_dir/server/Dockerfile $sim_build_dir

cd $script_dir/http/
rm -rf webgl/
cp -r $sim_build_dir/webgl/ webgl
docker build -t team766/2020sim-web:${version} .
rm -rf webgl/

cd $script_dir/robot_code/docker
docker build -t team766/robot-code:${version} .

cd $script_dir/api_endpoint
docker build -t team766/api-endpoint:${version} .

docker push team766/2020sim-web:${version}
docker push team766/2020sim:${version}
docker push team766/robot-code:${version}
docker push team766/api-endpoint:${version}

docker tag team766/2020sim-web:${version} team766/2020sim-web:latest
docker tag team766/2020sim:${version} team766/2020sim:latest
docker tag team766/robot-code:${version} team766/robot-code:latest
docker tag team766/api-endpoint:${version} team766/api-endpoint:latest
docker push team766/2020sim-web:latest
docker push team766/2020sim:latest
docker push team766/robot-code:latest
docker push team766/api-endpoint:latest

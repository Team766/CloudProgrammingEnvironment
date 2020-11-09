#!/bin/bash

# Run this script on your machine to deploy a new version of the simulator to a remote simulator VM
#
# Before running this script, build the simulator in Unity for WebGL and x86-64 server targets.
# The webgl target should be saved into $sim_build_dir with a name of `webgl` and the server
# target should be saved into $sim_build_dir/server with a name of `server`

set -euo pipefail

# A version string to use to tag the new version of the simulator, such as 0.12.1
version=$1
# The directory containing the builds of the Unity simulator project
sim_build_dir=$2
# The hostname of the remote simulator VM
hostname=$3

script_dir="$( dirname "${BASH_SOURCE[0]}" )"

docker build -t localhost:5000/frc2020-sim:$version -f $script_dir/server/Dockerfile $sim_build_dir

cd $script_dir/http/
rm -rf webgl/
cp -r $sim_build_dir/webgl/ webgl
docker build -t localhost:5000/frc2020-sim-web:$version .

ssh -L 5000:localhost:5000 root@$hostname
docker push localhost:5000/frc2020-sim-web:$version
docker push localhost:5000/frc2020-sim:$version

ssh root@$hostname \
  docker run -d \
    --name sim \
    --restart=always \
    --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
    -p 1735:1735 -p 1130:1130 -p 1140:1140 -p 5800-5810:5800-5810 -p 7778:7778 \
    localhost:5000/frc2020-sim:$version

ssh root@$hostname \
  docker run -d \
    --name sim-web \
    --restart=always \
    --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
    -p 80:80 \
    localhost:5000/frc2020-sim-web:$version

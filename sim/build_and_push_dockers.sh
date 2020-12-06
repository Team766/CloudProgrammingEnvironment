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
# The hostname of the remote simulator VM
hostname=${3-}

script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

docker build -t localhost:5000/frc2020-sim:$version -f $script_dir/server/Dockerfile $sim_build_dir

cd $script_dir/http/
rm -rf webgl/
cp -r $sim_build_dir/webgl/ webgl
docker build -t localhost:5000/frc2020-sim-web:$version .
rm -rf webgl/

if [ -n "$hostname" ]; then
  $script_dir/push_dockers.sh $version $hostname
fi

docker tag localhost:5000/frc2020-sim-web:$version team766/2020sim:${version}-web
docker tag localhost:5000/frc2020-sim:$version team766/2020sim:${version}-sim
docker push team766/2020sim:${version}-web
docker push team766/2020sim:${version}-sim

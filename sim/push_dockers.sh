#!/bin/bash

# Run this script on your machine to deploy a new version of the simulator to a remote simulator VM
#
# This script should be run after build_and_push_dockers.sh in order to deploy to additional VMs

set -euo pipefail

# A version string to use to tag the new version of the simulator, such as 0.12.1
version=$1
# The hostname of the remote simulator VM
hostname=$2

ssh -N -L 5000:localhost:5000 root@$hostname &
tunnel_pid=$!
trap "kill $tunnel_pid" EXIT
# Wait for SSH to connect
sleep 10

docker push localhost:5000/frc2020-sim-web:$version
docker push localhost:5000/frc2020-sim:$version
docker push localhost:5000/robot_code:latest

ssh root@$hostname \
  docker stop sim
ssh root@$hostname \
  docker stop sim-web
ssh root@$hostname \
  docker rm sim
ssh root@$hostname \
  docker rm sim-web

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

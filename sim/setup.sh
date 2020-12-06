#!/bin/bash

# Run this script on a new simulator VM

set -euo pipefail

apt update
apt install -y docker.io
docker run --name registry -p 127.0.0.1:5000:5000 --restart=always -d registry:2

systemctl enable docker

docker run -d \
  --name sim \
  --restart=always \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
  -p 1735:1735 -p 1130:1130 -p 1140:1140 -p 5800-5810:5800-5810 -p 7778:7778 \
  team766/2020sim:0.19.4-sim

docker run -d \
  --name sim-web \
  --restart=always \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
  -p 80:80 \
  team766/2020sim:0.19.4-web

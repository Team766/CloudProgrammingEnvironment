#!/bin/bash

# Run this script on a new simulator VM

set -euo pipefail

domain_name="$1"

script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

apt update
apt install -y docker.io
docker run --name registry -p 127.0.0.1:5000:5000 --restart=always -d registry:2

systemctl enable docker

cp $script_dir/launch_robot_code.sh /usr/local/bin/launch_robot_code.sh

docker pull team766/robot-code
docker tag team766/robot-code localhost:5000/robot_code:latest

docker run -d \
  --name sim \
  --restart=always \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
  -p 1735:1735 -p 1130:1130 -p 1140:1140 -p 5800-5810:5800-5810 -p 7778:7778 \
  team766/2020sim:0.19.4-sim

docker run -d \
  --name sim-web \
  --restart=always \
  --env "VIRTUAL_HOST=${domain_name}" \
  --env "VIRTUAL_PORT=80" \
  --env "LETSENCRYPT_HOST=${domain_name}" \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
  team766/2020sim:0.19.4-web

if [ -z "$(docker ps -q --filter "name=^nginx-proxy\$")" ]; then
  docker run --detach \
    --restart=always \
    --publish 80:80 \
    --publish 443:443 \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    --volume /etc/nginx/certs \
    --volume /etc/nginx/vhost.d \
    --volume /usr/share/nginx/html \
    --name nginx-proxy \
    jwilder/nginx-proxy
fi

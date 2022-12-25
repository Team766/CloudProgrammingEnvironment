#!/bin/bash

# Run this script on a new simulator VM

set -euo pipefail

# The hostname of the simulator VM
domain_name="$1"

script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

set -x

apt update
env DEBIAN_FRONTEND=noninteractive apt install -y docker.io

systemctl enable docker

cp "$script_dir/launch_robot_code.sh" /usr/local/bin/launch_robot_code.sh

if [ -n "$(docker ps -a -q --no-trunc --filter 'name=^robot_code$')" ]; then
  docker stop robot_code
fi
docker pull team766/robot-code

if [ -n "$(docker ps -a -q --no-trunc --filter 'name=^sim$')" ]; then
  docker stop sim
  docker rm sim
fi
docker pull team766/2020sim
docker run -d \
  --name sim \
  --restart=always \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
  -p 1735:1735 -p 1130:1130 -p 1140:1140 -p 5800-5810:5800-5810 -p 7778:7778 \
  team766/2020sim

if [ -n "$(docker ps -a -q --no-trunc --filter 'name=^sim-web$')" ]; then
  docker stop sim-web
  docker rm sim-web
fi
docker pull team766/2020sim-web
docker run -d \
  --name sim-web \
  --restart=always \
  --env "VIRTUAL_HOST=${domain_name}" \
  --env "VIRTUAL_PORT=80" \
  --env "HTTPS_METHOD=nohttps" \
  --env "LETSENCRYPT_HOST=${domain_name}" \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
  team766/2020sim-web

if [ -n "$(docker ps -a -q --no-trunc --filter 'name=^api-endpoint$')" ]; then
  docker stop api-endpoint
  docker rm api-endpoint
fi
docker pull team766/api-endpoint
docker run -d \
  --name api-endpoint \
  --restart=always \
  --publish 4000:4000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp/robot_code:/mnt/robot_code `# These paths need to match sim/api_endpoint/app/main.py` \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
  team766/api-endpoint

if [ -z "$(docker ps -q --filter 'name=^nginx-proxy$')" ]; then
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

echo "Setup finished"

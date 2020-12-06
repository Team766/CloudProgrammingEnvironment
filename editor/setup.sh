#!/bin/bash

# Run this script on a new code editor VM

set -euo pipefail

adduser --disabled-password --gecos '' coder

mkdir -p /app/ssh
ssh-keygen -f /app/ssh/id_rsa -t rsa -b 4096 -q -N ""
chown -R coder:coder /app

mkdir -p /mnt/code_storage
touch /mnt/code_storage/sim_robots.lst
chown -R coder:coder /mnt/code_storage

apt update
apt install -y docker.io

systemctl enable docker

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

docker run --detach \
    --restart=always \
    --name nginx-proxy-letsencrypt \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    jrcs/letsencrypt-nginx-proxy-companion

docker run --detach \
    --restart=always \
    --name oauth2-proxy \
    bitnami/oauth2-proxy

cd docker
docker build -t editor --build-arg uid=$(id -u coder) .

#!/bin/bash

# Run this script on a new simulator VM

set -euo pipefail

apt update
apt install -y docker.io
docker run --name registry -p 127.0.0.1:5000:5000 --restart=always -d registry:2

systemctl enable docker

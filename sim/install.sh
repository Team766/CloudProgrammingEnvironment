#!/bin/bash

# Run this script from your computer to set up a remote simulator VM
# Run ./build_and_push_dockers.sh after running this script.

set -euo pipefail

hostname=$1

scp launch_robot_code.sh root@${hostname}:/usr/local/bin

scp setup.sh root@${hostname}:
ssh root@$hostname ./setup.sh

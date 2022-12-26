#!/bin/bash

# Run this script from your computer to set up a remote simulator VM
# Run ./build_and_push_dockers.sh after running this script.

set -euo pipefail

hostname="$1"
shift

script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

scp "$script_dir/launch_robot_code.sh" "root@${hostname}:"
scp "$script_dir/setup.sh" "root@${hostname}:"
ssh "root@$hostname" ./setup.sh "${hostname}" "$@"

#!/bin/bash

# Run this script from your computer to set up a remote code editor VM

set -euo pipefail

hostname=$1

script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

scp -r $script_dir/* root@${hostname}:

ssh root@${hostname} ./setup.sh

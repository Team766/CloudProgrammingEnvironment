#!/bin/bash

# Run this script from your computer to set up a remote code editor VM

set -euo pipefail

hostname=$1

scp -r . root@${hostname}:

ssh root@${hostname} ./setup.sh

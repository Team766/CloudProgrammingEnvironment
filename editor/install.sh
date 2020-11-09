#!/bin/bash

# Run this script from your computer to set up a remote code editor VM

set -euo pipefail

scp -r . root@code.team766.com:

ssh root@code.team766.com ./setup.sh

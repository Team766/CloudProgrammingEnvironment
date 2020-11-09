#!/bin/bash

set -euo pipefail

git config --global user.email "${EDITOR_NAME}@code.team766.com"
git config --global user.name "${EDITOR_NAME}"

/usr/bin/code-server --bind-addr 0.0.0.0:3000 /home/project --auth=none

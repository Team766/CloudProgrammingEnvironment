#!/bin/bash

set -euo pipefail

git config --global user.email "${EDITOR_USER_EMAIL}"
git config --global user.name "${EDITOR_USER_NAME}"

/usr/bin/code-server --bind-addr 0.0.0.0:3000 /home/project --auth=none

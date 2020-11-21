#!/bin/bash

set -euo pipefail
set -x

instance_name="$1"
host_name="$2"

storage="/mnt/code_storage/${instance_name}"
container_name="code.${instance_name}"
domain_name="${instance_name}.${host_name}"

if [ ! -d "$storage" ]; then
        git clone https://github.com/Team766/MaroonFramework.git "$storage" || { rm -rf "$storage"; exit 1; }
	chown -R coder:coder "$storage"
fi

if [ -z "$(docker ps -q --filter "name=${container_name}")" ]; then
        docker run -d --rm \
		--env "VIRTUAL_HOST=${domain_name}" \
		--env "VIRTUAL_PORT=3000" \
		--env "LETSENCRYPT_HOST=${domain_name}" \
		--env "EDITOR_USER_NAME=${instance_name}" \
		--env "EDITOR_USER_EMAIL=${instance_name}@${host_name}" \
		--volume "${storage}:/home/project" \
		--volume /app/ssh:/home/coder/.ssh \
		--name "$container_name" \
		editor
fi

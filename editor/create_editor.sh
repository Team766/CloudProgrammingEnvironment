#!/bin/bash

set -euo pipefail
set -x

instance_name="$1"
host_name="$2"

storage_root="/mnt/code_storage"
storage="${storage_root}/${instance_name}"
container_name="code.${instance_name}"
domain_name="${instance_name}.${host_name}"

if [ ! -d "$storage" ]; then
        git clone https://github.com/Team766/MaroonFramework.git "$storage" || { rm -rf "$storage"; exit 1; }
	chown -R coder:coder "$storage"
fi

if [ -z "$(docker ps -q --filter "name=^${container_name}\$")" ]; then
	docker run -d \
		--restart=always \
		--log-driver json-file --log-opt max-size=10m --log-opt max-file=10 \
		--env "VIRTUAL_HOST=${domain_name}" \
		--env "VIRTUAL_PORT=3000" \
		--env "LETSENCRYPT_HOST=${domain_name}" \
		--env "EDITOR_USER_NAME=${instance_name}" \
		--env "EDITOR_USER_EMAIL=${instance_name}@${host_name}" \
		--volume "${storage}:/home/project" \
		--volume "${storage_root}/sim_robots.lst:/home/project/sim_robots.lst" \
		--volume /app/ssh:/home/coder/.ssh \
		--name "$container_name" \
		editor
fi

while [[ "$(curl -s -o /dev/null -w '%{http_code}' "https://${domain_name}/?folder=/home/project")" != "200" ]]; do
	docker logs "$container_name"
	echo "Waiting for service to start on https://${domain_name}"
	sleep 5;
done

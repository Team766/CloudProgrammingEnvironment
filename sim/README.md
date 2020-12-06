simulator VM environment
========================

To setup a simulator VM:
- Provision a new VM with at least 2 CPU cores
- Run `./install.sh <sim VM hostname>`
- From the code editor VM, run `ssh-copy-id -o "StrictHostKeyChecking=no" -i /app/ssh/id_rsa.pub root@$SIM_HOSTNAME` and `echo $SIM_HOSTNAME >> /mnt/code_storage/sim_robots.lst`

To build a new version of the simulator container images:
- Build the simulator in Unity for WebGL and x86-64 server targets, as described in the comments of [`build_and_push_dockers.sh`](./build_and_push_dockers.sh)
- Run `./build_and_push_dockers.sh`

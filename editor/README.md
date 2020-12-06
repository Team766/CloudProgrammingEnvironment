editor VM environment
=====================

To setup the code editor VM:
- Provision a new VM with permanent storage for user code attached at `/mnt/code_storage`
- Run `./install.sh <editor VM hostname>`
- In the VM, run `./create_editor.sh <editor name> <editor VM hostname>` for each code editor environment you want to setup

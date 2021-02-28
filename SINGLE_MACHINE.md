set up a DNS wildcard rule for \*.DOMAIN_NAME to point to your server


starting from Digital Ocean's default install of Ubuntu 20.04

```
DOMAIN_NAME=

git clone https://github.com/Team766/CloudProgrammingEnvironment.git

cd ~/CloudProgrammingEnvironment/editor/
./setup.sh

cd ~/CloudProgrammingEnvironment/sim/
./setup.sh sim.$DOMAIN_NAME

echo sim.$DOMAIN_NAME >> /mnt/code_storage/sim_robots.lst

cat /app/ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys

cd ~/CloudProgrammingEnvironment/editor/
./create_editor.sh test-editor $DOMAIN_NAME
```

You can now visit http://test-editor.DOMAIN_NAME

You can run the last command multiple times to add additional programming environment instances for your different users

# Basic commands
Navigate to folder with Vagrantfile, then:
```bash
  vagrant up               # turn on VM
  vagrant ssh              # log into new VM
  vagrant halt             # turn off VM
  vagrant suspend          # pause VM
  vagrant reload           # after edits to Vagrantfile
  vagrant destroy          # destroy VM but leave box installed
  vagrant box remove NAME  # remove the box that was installed with vagrant up
```

# Provisioning a new VM
```bash
cd ~/vagboxes
mkdir app-dev
cd app-dev
mkdir shared
vagrant box add ubuntu/xenial64      # ubuntu 16.04
vagrant box add ubuntu/bionic64      # ubuntu 18.04
vagrant box add bento/ubuntu-20.04   # ubuntu 20.04
vagrant init ubuntu/bionic64
vagrant up
vagrant ssh
```

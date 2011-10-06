#!/bin/bash

# Add Git-User
user="git"
groupadd wwwadmin >/dev/null 2>&1
useradd -s /bin/bash -g wwwadmin -m ${user}
sudo -u ${user} -i "ssh-keygen -t rsa -f /home/${user}/.ssh/${user}-$(hostname) -P ''"
sudo -u ${user} -i "cat >> /home/${user}/.ssh/config <<EOF 
Host krankigit git.krankikom.de
Hostname git.krankikom.de
IdentityFile ~/.ssh/${user}-$(hostname)
EOF"


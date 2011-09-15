#!/bin/bash

echo "Basic install ..."

echo "Adjusting sources.list"
cat >> /etc/apt/sources.list << EOF

deb http://repo.percona.com/apt lucid main
deb-src http://repo.percona.com/apt lucid main
deb http://repos.zend.com/zend-server/deb server non-free
EOF

echo "Adding APT Keys"
wget http://repos.zend.com/zend.key -O- |apt-key add -
wget http://repo.percona.com/apt/RPM-GPG-KEY-percona -O- |apt-key add -

aptitude update

cat >> /root/.bashrc << EOF
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi
EOF

echo "# Security: Disable the verify command" >> /etc/postfix/main.cf 
echo "disable_vrfy_command = yes" >> /etc/postfix/main.cf

# Only if nothing has been setup
if [ ! -f /etc/motd.tail ]; then 

cat >> /etc/motd.tail <<EOF

####################################################################
# Server Info:                                                     #
####################################################################

EOF
ipmitool fru|grep -v "Chassis Type" | sed 's/FRU Device Description :/ FRU Device Description:/' |sed 's/\t/  /' >> /etc/motd.tail

cat >> /etc/update-motd.d/99-footer <<EOF

echo " CPU Information       : $(cat /proc/cpuinfo| egrep -c "^processor")x$(cat /proc/cpuinfo|egrep "^model name"|head -1|awk -F: '{print $2}'|tr -s ' ')"
echo " Total Memory          :$(cat /proc/meminfo| egrep "^MemTotal:"|awk -F: '{print $2}'|tr -s ' ')"
echo ""
echo " ServerName            : $(hostname --fqdn)"
echo ""
EOF

fi

#!/bin/bash

cat >> /etc/logrotate.d/cbx << EOF
# Apache Logfile rotation
/cbx/logs/*_log
{
        daily
        missingok
        rotate 180
        dateext
        compress
        delaycompress
        # Apache is root, php errors are www-data
        create 664 root www-data
        sharedscripts
        postrotate
                if [ -f "`. /etc/apache2/envvars ; echo ${APACHE_PID_FILE:-/var/run/apache2.pid}`" ]; then
                        /etc/init.d/apache2 reload > /dev/null
                fi
        endscript
}
EOF


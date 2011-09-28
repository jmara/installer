#!/bin/bash

echo "Webserver install ..."
s=$(cat web.pkglist)
aptitude install $s

echo "Change default php.ini values"

sed -i "s/^error_reporting  =  E_ALL$/error_reporting=E_ALL \& ~E_NOTICE/" /usr/local/zend/etc/php.ini |grep "^error_reporting" /usr/local/zend/etc/php.ini
sed -i "s/^;date.timezone =$/date.timezone = \"Europe\/London\"/" /usr/local/zend/etc/php.ini |grep "^timezone" /usr/local/zend/etc/php.ini
sed -i "s/^expose_php = On$/expose_php = Off/" /usr/local/zend/etc/php.ini |grep "^expose_php" /usr/local/zend/etc/php.ini
sed -i "s/^;upload_tmp_dir =$/upload_tmp_dir=\"\/tmp\"/" /usr/local/zend/etc/php.ini |grep "^upload_tmp_dir" /usr/local/zend/etc/php.ini

echo "Change Apache Security"

sed -i "s/^ServerTokens OS$/ServerTokens Prod/" /etc/apache2/conf.d/security
sed -i "s/^ServerSignature On$/ServerSignature Off/" /etc/apache2/conf.d/security
echo "UseCanonicalName On" >> /etc/apache2/conf.d/security


echo "Change DefaultCharset to UTF8"

sed -i "s/^#AddDefaultCharset UTF-8$/AddDefaultCharset UTF-8/" /etc/apache2/conf.d/charset

echo "Enable Status for KK-Ips"

sed -i "s/^<\/Location>$/    Allow from 194.77.169\\n<\/Location>/" /etc/apache2/mods-available/status.conf

a2enmod expires; a2enmod headers; a2enmod status

service zend-server restart

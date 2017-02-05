#!/bin/sh
sed -i "s/SERVICENAME/${SERVICENAME}/g" /etc/apache2/sites-enabled/000-default.conf
sed -i "s/EMAIL/${EMAIL}/g" /etc/apache2/sites-enabled/000-default.conf
/etc/init.d/cron start
/etc/init.d/apache2 start
sudo -u otrs /opt/otrs/bin/otrs.Console.pl Admin::Package::Reinstall OTRSMasterSlave
tail -f /var/log/apache2/error.log

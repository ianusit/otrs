#!/bin/sh
/etc/init.d/cron start
/etc/init.d/apache2 start
sudo -u otrs /opt/otrs/bin/otrs.Console.pl Admin::Package::Reinstall OTRSMasterSlave
tail -f /var/log/apache2/error.log

#!/bin/sh
cp /defaults/* /etc/apache2/sites-enabled/
/etc/init.d/cron start
/etc/init.d/apache2 start
tail -f /var/log/apache2/error.log

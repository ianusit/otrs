FROM debian:jessie

MAINTAINER Ianus IT GmbH <info@ianus-it.de>

RUN apt-get update &&\
    apt-get install -y wget gzip tar apache2 libdbd-pg-perl libapache2-mod-perl2 libtimedate-perl libnet-dns-perl libio-socket-ssl-perl libpdf-api2-perl libsoap-lite-perl libtext-csv-xs-perl libjson-xs-perl libapache-dbi-perl libxml-libxml-perl libxml-libxslt-perl libyaml-perl libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl libtemplate-perl sudo cron &&\
    wget http://ftp.otrs.org/pub/otrs/otrs-5.0.34.tar.gz &&\
    tar xfz /otrs-5.0.34.tar.gz &&\
    rm /otrs-5.0.34.tar.gz &&\
    mv otrs-5.0.34 /opt/otrs &&\
    cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm &&\
    cp /opt/otrs/var/cron/otrs_daemon.dist /opt/otrs/var/cron/otrs_daemon &&\
    useradd -d /opt/otrs/ -c 'OTRS user' otrs &&\
    usermod -G www-data otrs &&\
    perl /opt/otrs/bin/otrs.SetPermissions.pl --otrs-user=otrs --web-group=www-data /opt/otrs &&\
    sudo -u otrs /opt/otrs/bin/Cron.sh start &&\
    a2enmod ssl &&\
    a2enmod perl &&\
    a2enmod deflate &&\
    a2enmod filter &&\
    a2enmod headers &&\
    ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/conf-enabled/zzz_otrs.conf &&\
    apt-get remove -y wget exim4 exim4-base exim4-config exim4-daemon-light &&\
    apt-get autoremove -y &&\
    apt-get clean

COPY files/defaults /defaults
COPY files/start.sh /

RUN chmod +x /start.sh

CMD ["/start.sh"]

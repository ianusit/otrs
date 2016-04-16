FROM debian:jessie

MAINTAINER Ianus IT GmbH <info@ianus-it.de>

RUN apt-get update &&\
    apt-get install -y wget zip libapache2-mod-perl2 libdbd-pg-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libsoap-lite-perl libgd-text-perl libtext-csv-xs-perl libjson-xs-perl libgd-graph-perl libapache-dbi-perl libarchive-zip-perl libcrypt-eksblowfish-perl libmail-imapclient-perl libtemplate-perl libyaml-libyaml-perl libxml-libxml-perl libxml-libxslt-perl apache2 sudo cron &&\
    wget http://ftp.otrs.org/pub/otrs/otrs-5.0.9.zip &&\
    unzip /otrs-5.0.9.zip &&\
    rm /otrs-5.0.9.zip &&\
    mv otrs-5.0.9 /opt/otrs &&\
    useradd -d /opt/otrs/ -c 'OTRS user' otrs &&\
    usermod -G www-data otrs &&\
    perl /opt/otrs/bin/otrs.SetPermissions.pl --web-group=www-data &&\
    sudo -u otrs /opt/otrs/bin/Cron.sh start &&\
    a2enmod ssl &&\
    a2enmod perl &&\
    a2enmod deflate &&\
    a2enmod filter &&\
    a2enmod headers &&\
    ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/conf-enabled/zzz_otrs.conf &&\
    apt-get remove -y wget zip &&\
    apt-get autoremove -y
    
COPY files/start.sh /

RUN chmod +x /start.sh

CMD ["/start.sh"]

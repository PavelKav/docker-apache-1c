#this container based in standart image Debian+Apache 2.4: https://hub.docker.com/_/httpd
FROM httpd:latest
#update
RUN apt update && apt upgrade -y
MAINTAINER Pavel Kaverzin <nizrevak6@yandex.ru>
#copy deb64 in directory
COPY deb64.tar.gz /opt/install/deb64.tar.gz

#unpack archive in directory /opt/install
RUN tar xzf /opt/install/deb64.tar.gz -C /opt/install \
    #and run package install
    && /opt/install/*.run --mode unattended --installer-language en --enable-components ws,ru,liberica_jre \
    #remove dir after installation
    &&rm -rf /opt/install/
#copy in container httpd.conf
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

#copy in container default.vrd - config connection to 1c
COPY default.vrd /usr/local/apache2/htdocs/base_name/default.vrd

#set file permissions
RUN chown daemon:daemon /usr/local/apache2/htdocs/base_name/default.vrd

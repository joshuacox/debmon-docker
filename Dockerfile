FROM    debian:wheezy
MAINTAINER Josh Cox <josh 'at' webhosting coop>

ENV debmon_docker_updated 20140308
RUN echo "deb http://mirrors.liquidweb.com/debian/ wheezy main contrib non-free" > /etc/apt/sources.list
RUN echo "deb-src http://mirrors.liquidweb.com/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list

# debmon sources
RUN echo "deb http://debmon.org/debmon debmon-wheezy main" >> /etc/apt/sources.list
# RUN wget -O - http://debmon.org/debmon/repo.key 2>/dev/null | apt-key add - |sed 's/OK/0/'
RUN ["/bin/bash", "-c", "wget -O - http://debmon.org/debmon/repo.key 2>/dev/null | apt-key add -"]

RUN apt-get update
RUN apt-get -y upgrade

# RUN apt-get install -y debmon-keyring-package

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Basic Requirements
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nginx php5-fpm php5-mysql php-apc pwgen python-setuptools curl git unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libdbd-pgsql postgresql-client
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install icinga icinga-doc icinga-web nagios-plugins

# cleanup
RUN apt-get clean

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# Supervisor Config
RUN /usr/bin/easy_install supervisor
ADD ./supervisord.conf /etc/supervisord.conf

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# private expose
EXPOSE 80

CMD ["/bin/bash", "/start.sh"]

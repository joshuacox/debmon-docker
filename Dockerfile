FROM joshuacox/docker-chef-solo:jessie
MAINTAINER Josh Cox <josh 'at' webhosting coop>

ENV debmon_docker_updated 20140308
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

RUN echo "Installing berksfile..."
ADD ./Berksfile /Berksfile
ADD ./chef/roles /var/chef/roles
ADD ./chef/data_bags /var/chef/data_bags
ADD ./chef/solo.rb /var/chef/solo.rb
ADD ./chef/solo.json /var/chef/solo.json

RUN echo "Installing berks This may take a few minutes..."
RUN cd / && /opt/chef/embedded/bin/berks vendor /var/chef/cookbooks
RUN echo "Installing chef This may take a few minutes..."
RUN chef-solo -c /var/chef/solo.rb -j /var/chef/solo.json

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl  

ADD ./LICENSE /LICENSE
ADD ./README.md /README.md
ADD ./debmon-docker.txt /debmon-docker.txt
RUN cat "/LICENSE" "/README.md" "/debmon-docker.txt"

# Supervisor Config
RUN /usr/bin/easy_install supervisor
ADD ./supervisord.conf /etc/supervisord.conf

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# cleanup
RUN apt-get clean

EXPOSE 80
CMD ["/bin/bash", "/start.sh"]

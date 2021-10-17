FROM scratch
LABEL created by Jaci Coyle October 14th 2021

# This is the base image tarball for Centos 7
# Tarball provided by Anish on 8gwifi
# https://8gwifi.org/docs/docker-baseimage.jsp
ADD centos-7.2.1511-docker.tar.xz /

EXPOSE 80

# This pulls a workaround for systemd being supressed by Docker
# and gives the build systemd functionality
# It also takes the time to install necessary dependencies
# It does not update yum since that takes over 10 minutes
# and is not necessary to function

# Systemd workaround created by gdraheim on Github
# https://github.com/gdraheim/docker-systemctl-images
COPY gheim/files/docker/systemctl.py /usr/bin/systemctl
RUN yum install -y httpd httpd-tools elinks vim wget
COPY gheim/files/docker/systemctl.py /usr/bin/systemctl

# This enables the apache server with systemd
RUN systemctl enable httpd

#this pulls the website
RUN wget google.com > index.html

# wget automatically add a .1 onto index.html so this renames it
RUN mv index.html.1 index.html

# And moves the website into the correct place
RUN mv index.html /var/www/html/index.html
CMD /usr/bin/systemctl

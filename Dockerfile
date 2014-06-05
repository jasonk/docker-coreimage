FROM ubuntu:trusty
MAINTAINER Jason Kohles <email@jasonkohles.com>

# Some initial environmental setup
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C
ENV INITRD no

ADD before /
RUN /before.sh

# Upgrade everything.  This is here instead of in setup.sh because that way
# we can benefit from the cache (and the timestamps can be used to bust the
# cache when needed)
RUN apt-get update && apt-get upgrade -qy # 20140604
RUN apt-get autoremove && apt-get clean # 20140604

# Add our local configuration files, this should be the last step, because
# this is the stuff we are most likely to change, so everything up above can
# come from the cache..
ADD docker-utils/bin /usr/sbin/
ADD after /
RUN /after.sh

CMD [ "/sbin/runit" ]

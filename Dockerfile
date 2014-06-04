FROM ubuntu:trusty
MAINTAINER Jason Kohles <email@jasonkohles.com>

ADD . /.build
RUN /.build/install.sh && rm -rf /.build
CMD [ "/sbin/runit" ]

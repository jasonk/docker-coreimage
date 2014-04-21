#!/bin/bash

# Be careful about these!
rm -f  /etc/ssh/ssh_host_*
rm -f  /etc/hostid

rm -f  /var/cache/apt/archives/*.deb
rm -f  /var/cache/apt/archives/partial/*.deb
rm -f  /var/cache/apt/*.bin
rm -rf /usr/share/man
rm -rf /usr/local/share/man
rm -rf /usr/local/man
rm -rf /usr/share/doc
find   /var/log -name \*.log | xargs rm -f
rm -rf /var/log/upstart
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /etc/X11
rm -rf /etc/init /etc/init.d
rm -f  /etc/cron.daily/standard

rm -f  /var/cache/debconf/*-old
rm -rf /run/resolvconf
rm -f  /etc/update-motd.d/*

apt-get clean

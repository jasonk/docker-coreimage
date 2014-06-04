#!/bin/bash
set -e -x

DIVERT_COMMANDS="
    /sbin/initctl
    /usr/sbin/ischroot
"

INSTALL_PACKAGES="
    runit
    socklog-run
    xinetd
    curl
    unzip
    pwgen
    cron
    rsync
    git
    ntpdate
    software-properties-common
    apt-transport-https
";

REMOVE_PACKAGES="
    resolvconf
    ubuntu-minimal
";

HOLD_PACKAGES="
    upstart
    initscripts
";

SERVICE_STATES="
    xinetd=on
    cron=on
    sshd=off
";

###############################################################################

cd "$(dirname "$0")"

# Copy the raw filesystem directories into the filesystem
for I in usr etc srv; do
    test -d /$I || mkdir /$I
    cp -R $I/* /$I/
done

# Remove anything that might be in sources.list.d
rm -f /etc/apt/sources.list.d/*.list

# Update the environment with the files from /srv/environment
docker-coreimage environment --update
# And bring that environment into this script
. /srv/environment.sh

# Hold some packages
apt-mark hold $HOLD_PACKAGES

# Update the package metadata
apt-get update

# Configure diversions
for I in $DIVERT_COMMANDS; do
    dpkg-divert --local --rename --add $I
    ln -sf /usr/sbin/log-diversion $I
done

# Remove some packages
test -n "$REMOVE_PACKAGES" && dpkg --purge $REMOVE_PACKAGES

# Install some packages
test -n "$INSTALL_PACKAGES" && apt-get install -qy $INSTALL_PACKAGES

# Upgrade packages
apt-get upgrade -qy

# Make sure the appropriate services are enabled and disabled
test -n "$SERVICE_STATES" && docker-coreimage service $SERVICE_STATES

# Install my docker-utils
git clone http://github.com/jasonk/docker-utils
cp -a docker-utils/bin/* /usr/bin/

# Cleanup
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

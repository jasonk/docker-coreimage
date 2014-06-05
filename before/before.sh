#!/bin/bash

cat <<END > /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ trusty main restricted universe
deb http://archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe
deb http://archive.ubuntu.com/ubuntu/ trusty-security main restricted universe
END

rm -f /etc/apt/sources.list.d/*.list

# Hold these so that they don't try to upgrade (and thus restart things)
apt-mark hold upstart initscripts

# Divert ischroot and initctl until we can replace them with versions that
# don't cause problems in a container..
for I in /sbin/initctl /usr/sbin/ischroot; do
    dpkg-divert --local --rename --add $I
    ln -sf /usr/sbin/log-diversion $I
done

# Remove some packages we don't want
apt-get remove -qy resolvconf ubuntu-minimal

PACKAGES=(
    runit socklog-run xinetd curl unzip pwgen cron rsync git ntpdate
    software-properties-common apt-transport-https
)
apt-get install -qy "${PACKAGES[@]}"

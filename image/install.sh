#!/bin/bash
set -e -x

INSTALL_PACKAGES=(
    runit
    socklog-run
    xinetd
    software-properties-common
    apt-transport-https
    curl
    unzip
    pwgen
    cron
    openssh-server
);
REMOVE_PACKAGES=(
    resolvconf ubuntu-minimal vim-common vim-tiny ntpdate
);

###############################################################################

cd "$(dirname "$0")"

test -d /srv || mkdir /srv
cp -a srv/* /srv/

cp -a bin/* /usr/bin/

docker-coreimage environment --update

. /srv/environment.sh

# Install our own sources.list
cat <<END > /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu saucy main restricted universe
deb http://archive.ubuntu.com/ubuntu saucy-updates main restricted universe
deb http://archive.ubuntu.com/ubuntu saucy-security main restricted universe
END
rm -f /etc/apt/sources.list.d/*.list

# Configure apt
echo 'APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/no-suggests
echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/no-recommends
echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/apt-speedup
echo 'Acquire::http {No-Cache=True;};' > /etc/apt/apt.conf.d/no-http-cache

# Add repositories
add-apt-repository -y ppa:rquillo/ansible

apt-get update

apt-get install ansible

# Divert some things we want to avoid running
for I in /sbin/initctl /usr/sbin/ischroot; do
    dpkg-divert --local --rename --add $I
    ln -sf /usr/bin/log-diversion $I
done

# Remove some packages
dpkg --purge "${REMOVE_PACKAGES[@]}"

# Install repositories
for I in "${INSTALL_REPOSITORIES[@]}"; do
    add-apt-repository "$I"
done

# Install some packages
apt-get install -y "${INSTALL_PACKAGES[@]}"

cp -a runit /etc/

#apt-get install -y language-pack-en
#rm -f /var/lib/locales/supported.d/*
#echo "en_US ISO-8859-1" > /var/lib/locales/supported.d/en
#locale-gen en_US

dpkg -l | egrep '^rc ' | awk '{print $2}' | xargs dpkg --purge

docker-coreimage service xinetd=on cron=on sshd=off

# Install configuration files
cp config/sshd_config /etc/ssh/sshd_config

rm -rf \
    /var/cache/apt/archives/*.deb           \
    /var/cache/apt/archives/partial/*.deb   \
    /var/cache/apt/*.bin                    \
    /usr/share/man                          \
    /usr/local/share/man                    \
    /usr/local/man                          \
    /usr/share/doc                          \
    /etc/X11                                \
    /etc/init /etc/init.d                   \
    /tmp/* /var/tmp/*                       \
    /etc/ssh/ssh_host_*                     \
    /etc/cron.daily/standard                \
    /var/log/*.log /var/log/*/*.log         \
    /var/log/upstart                        \

apt-get clean

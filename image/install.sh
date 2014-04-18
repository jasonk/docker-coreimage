#!/bin/bash
set -e -x

INSTALL_PPAS="
    ppa:rquillo/ansible
"

INSTALL_PACKAGES="
    runit
    socklog-run
    xinetd
    curl
    unzip
    pwgen
    cron
    openssh-server
    ansible
";

REMOVE_PACKAGES="
    resolvconf ubuntu-minimal vim-common vim-tiny ntpdate
";

SERVICE_STATES="
    xinetd=on
    cron=on
    sshd=off
";

###############################################################################

cd "$(dirname "$0")"

# Copy the raw filesystem directories into the filesystem
for I in srv usr etc; do
    test -d /$I || mkdir /$I
    cp -R $I/* /$I/
done

# Update the environment with the files from /srv/environment
docker-coreimage environment --update
# And bring that environment into this script
. /srv/environment.sh

# Configure diversions
./configure-diversions.sh

# Configure apt
./configure-apt.sh

# Add any ppa repositories
test -n "$INSTALL_PPAS" && add-apt-repository -y $INSTALL_PPAS

# Remove some packages
test -n "$REMOVE_PACKAGES" && dpkg --purge $REMOVE_PACKAGES

# Install some packages
test -n "$INSTALL_PACKAGES" && apt-get install -y $INSTALL_PACKAGES

test -n "$SERVICE_STATES" && docker-coreimage service $SERVICE_STATES

docker-coreimage cleanup --remove REALLY_SERIOUSLY_ALL
apt-get clean

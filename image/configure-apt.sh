#!/bin/bash
set -e

URL=${APT_URL:-http://archive.ubuntu.com/ubuntu}
REL=${APT_RELEASE:-saucy}
SUFF=${APT_SUFFIXES:-updates security}
COMPS=${APT_COMPONENTS:-main restricted universe}

HOLD_PACKAGES="
    upstart
    initscripts
"

INSTALL_PACKAGES="
    software-properties-common
    apt-transport-https
"

###########################################################

# Install our own sources.list
(
    echo "deb $URL $REL $COMPS"
    for I in $SUFF; do
        echo "deb $URL $REL-$I $COMPS"
    done
) > /etc/apt/sources.list

rm -f /etc/apt/sources.list.d/*.list

# Configure apt
echo 'APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/no-suggests
echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/no-recommends
echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/apt-speedup
echo 'Acquire::http {No-Cache=True;};' > /etc/apt/apt.conf.d/no-http-cache

apt-mark hold $HOLD_PACKAGES
apt-get update

./configure-diversions.sh

apt-get install -y $INSTALL_PACKAGES
apt-get upgrade -y

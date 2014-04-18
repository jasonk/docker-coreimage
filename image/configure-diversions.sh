#!/bin/bash
set -e -x

DIVERT_COMMANDS="
    /sbin/initctl
    /usr/sbin/ischroot
"

###########################################################

# Divert some things we don't want to run (TODO: replace these with our
# own version that works appropriately)
for I in $DIVERT_COMMANDS; do
    dpkg-divert --local --rename --add $I
    ln -sf /usr/sbin/log-diversion $I
done

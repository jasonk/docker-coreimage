#!/bin/bash
# utility functions for the runit startup scripts

exec 2>&1

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

/usr/sbin/docker-coreimage environment sh > /etc/environment.sh
. /etc/environment.sh

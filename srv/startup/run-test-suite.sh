#!/bin/bash

mountpoint /test-suite > /dev/null 2>&1 || exit 0

(
    sleep 15
    cd /test-suite
    for I in *; do
        if [ -f $I -a -x $I ]; then ./$I; fi
    done
) &

exit 0

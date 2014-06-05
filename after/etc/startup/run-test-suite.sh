#!/bin/bash
shopt -s nullglob

if ! mountpoint -q /test-suite; then exit 0; fi

COUNTER=15 # wait 15 seconds to allow the system to settle
(
    echo "Initiating test suite"

    while [ $COUNTER -gt 0 ]; do
        echo "Waiting for system to settle... $COUNTER..."
        let COUNTER=COUNTER-1
        sleep 1
    done
    echo "Beginning test run now"
    cd /test-suite
    (
        for I in *; do
            if [ -f $I -a -x $I ]; then ./$I; fi
        done
    ) | tee output.log
    runit-init 0
) &
exit 0;

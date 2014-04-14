#!/bin/bash

(
    cd /test-suite
    ./roundup.sh tests/*.sh
    echo "RESULT=$?"
) | tee /test-suite/output.log
runit-init 0

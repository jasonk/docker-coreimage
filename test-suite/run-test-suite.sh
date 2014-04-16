#!/bin/bash

(
    ./lib/roundup.sh ./tests/*.sh
    echo "RESULT=$?"
) | tee /test-suite/output.log

# Shutdown after running the test suite
runit-init 0

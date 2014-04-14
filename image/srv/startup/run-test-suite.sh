#!/bin/bash

echo "Run test suite?"
ls -l /test-suite
mount

if [ -f /test-suite/run-test-suite.sh ]; then
    ( sleep 15 ; /test-suite/run-test-suite.sh ) &
fi

exit 0

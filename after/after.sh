#!/bin/bash

update-service --add /etc/sv/cron
update-service --add /etc/sv/xinetd

make-pristine-container

rm -f /before.sh /after.sh

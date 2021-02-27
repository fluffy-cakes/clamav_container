#!/bin/bash

WATCHDIR='/data/scan'
printf "Waiting for changes to %s ...\n" "${WATCHDIR} "
inotifywait -m -r -q -t 0 -e moved_to,close_write ${WATCHDIR} | while read -r path action file; do
    /usr/local/bin/scanner.sh
done

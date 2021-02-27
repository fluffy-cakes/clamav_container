#!/bin/bash

PATHS=(/data/done /data/scan /var/log/cron)
for i in "${PATHS[@]}"; do
    mkdir -p "${i}"
done

printf "Fetching latest ClamAV virus definitions ...\n"
freshclam

# start supervisors, which spawns cron and inotify launcher
printf "Starting supervisord ...\n"
/usr/bin/supervisord -c /usr/local/supervisor.conf
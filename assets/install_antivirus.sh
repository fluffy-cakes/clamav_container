#!/bin/sh

# setup cron to update virus signatures hourly
cd /usr/local || exit
echo "0 * * * * /usr/bin/freshclam >> /var/log/cron/general.log 2>&1" >> tempcrons
crontab tempcrons
rm tempcrons

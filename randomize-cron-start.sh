#! /bin/sh

# randomize start of php cron job and run once per hour`
sed -i "s/^[0-9,]\+/$(echo $((RANDOM%60)))/;" /etc/cron.d/php
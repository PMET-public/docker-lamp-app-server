#!/bin/sh

# runit script

# change the user and group id of www-data to match the owner and group of the app dir
if [ ! -z "${APP_DIR}" ]; then
  OLDUID=$(id -u www-data)
  OLDGID=$(id -g www-data)
  NEWUID=$(stat -c "%u" "${APP_DIR}")
  NEWGID=$(stat -c "%g" "${APP_DIR}")
  # avoid subsequent runs (due to restart) if uid has already been updated
  if [ "${OLDGID}" != "${NEWGID}" ]; then
    usermod -u "${NEWUID}" www-data    
    groupmod -g "${NEWGID}" www-data
    find / -user "${OLDUID}" -exec chown -h "${NEWUID}" {} \;
    find / -group "${OLDGID}" -exec chgrp -h "${NEWGID}" {} \;
    usermod -g "${NEWGID}" www-data
  fi
fi

. /etc/apache2/envvars
exec /usr/sbin/apache2 -D NO_DETACH

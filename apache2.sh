#!/bin/sh

# runit script

. /etc/apache2/envvars
exec /usr/sbin/apache2 -D NO_DETACH

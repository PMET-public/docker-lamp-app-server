#!/bin/sh

# runit script

. /etc/apache2/envvars
/usr/sbin/apache2 -D FOREGROUND

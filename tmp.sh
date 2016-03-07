#!/bin/bash

eval "echo \"$(< /etc/ssmtp/ssmtp.conf.tmpl)\"" > /etc/ssmtp/ssmtp.conf


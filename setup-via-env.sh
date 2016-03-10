#!/bin/sh

# allow the passing of a SETUP_SCRIPT via the env rather than copying or linking it to /etc/my_init.d/.

if [ "${SETUP_SCRIPT}" != "" ]; then
  if [ -x "${SETUP_SCRIPT}" ]; then
     exec "${SETUP_SCRIPT}" &
  else 
    echo "${SETUP_SCRIPT} is not an executable file" 
  fi
fi

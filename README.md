# docker-lamp-app-server

This image creates an apache2 app server intended to communicate with a linked mysql compatible db server.

Features:
- mod_pagespeed included
- xdebug included but not enabled

Available env vars:
- INIT_SCRIPT
- STARTUP_SCRIPT
- WEB_SERVER_USER
- XDEBUG_REMOTE_HOST
- XDEBUG_REMOTE_PORT

Available env vars due to docker link:
- DB_ENV_DB_NAME
- DB_ENV_DB_USER
- DB_ENV_DB_PASS

Just add your apache configuration and your application via a volume and you're good to go.

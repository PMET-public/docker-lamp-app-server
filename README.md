# docker-lamp-app-server

This image creates an apache2 app server intended to communicate with a linked mysql compatible db server.

Features:
- mod_pagespeed included
- xdebug included but not enabled

Available env vars:
- SETUP_SCRIPT
- WEB_SERVER_USER (www-data)
- XDEBUG_REMOTE_HOST (127.0.0.1)
- XDEBUG_REMOTE_PORT (9000)

Available env vars due to docker link:
- DB_ENV_DB_NAME
- DB_ENV_DB_USER
- DB_ENV_DB_PASS

Just add your apache configuration and your application via a volume and you're good to go.

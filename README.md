# docker-lamp-app-server

This image creates an apache2 app server intended to connect to a mysql compatible service

Features:
- xdebug included but not enabled

Available env vars:
- SETUP_SCRIPT
- XDEBUG_REMOTE_HOST (127.0.0.1)
- XDEBUG_REMOTE_PORT (9000)

Just add your apache configuration and your application via a volume and you're good to go.

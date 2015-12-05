# docker-lamp-app-server

This image creates an apache2 app server intended to communicate with a linked mysql compatible db server.

Available env vars:
- SETUP_SCRIPT
- WEB_SERVER_USER (www-data)

Available env vars due to docker link:
- DB_SERVER_ENV_DB_NAME
- DB_SERVER_ENV_DB_USER
- DB_SERVER_ENV_DB_PASS

Just add your apache configuration and your application via a volume and you're good to go.

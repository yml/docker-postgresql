#!/bin/bash
# Starts up postgresql within the container.

# Stop on error
set -xe

POSTGRESQL_USER=${POSTGRESQL_USER:-"docker"}
POSTGRESQL_PASSWORD=${POSTGRESQL_PASSWORD:-"docker"}
POSTGRESQL_USER_DB=${POSTGRESQL_USER_DB:-"docker"}
POSTGRESQL_PROJECT_DB=${POSTGRESQL_PROJECT_DB:-"botbot"}
POSTGRESQL_TEMPLATE=${POSTGRESQL_TEMPLATE:-"DEFAULT"}
POSTGRESQL_DATA=${POSTGRESQL_DATA:-"/data"}

POSTGRESQL_PID=/var/run/postgresql/9.3-main.pid
POSTGRESQL_BIN=/usr/lib/postgresql/9.3/bin/postgres
POSTGRESQL_CONFIG_DIR=/etc/postgresql/9.3/main/


# test if POSTGRESQL_DATA has content
if [[ ! "$(ls -A $POSTGRESQL_DATA)" ]];
then
    echo "Initializing PostgreSQL at $POSTGRESQL_DATA"
    # Copy the data that we generated within the container to the empty POSTGRESQL_DATA.
    cp -R /var/lib/postgresql/9.3/main/* $POSTGRESQL_DATA
    # Ensure postgres owns the POSTGRESQL_DATA and that it has the appropriate permissions
    chown -R postgres:postgres $POSTGRESQL_DATA
    chmod -R 700 $POSTGRESQL_DATA
    # Start postgreSQL service
    sudo -u postgres $POSTGRESQL_BIN -D $POSTGRESQL_CONFIG_DIR &
    sudo -u postgres psql --command "CREATE USER $POSTGRESQL_USER WITH SUPERUSER PASSWORD '$POSTGRESQL_PASSWORD';"
    sudo -u postgres createdb -O $POSTGRESQL_USER $POSTGRESQL_USER_DB
    sudo -u postgres createdb -O $POSTGRESQL_USER $POSTGRESQL_PROJECT_DB
    # Stop PostgreSQL service
    PID=`cat $POSTGRESQL_PID`
    kill $PID && while ps -p $PID; do sleep 1;done;
    # Start PostgreSQL in the foreground
    sudo -u postgres $POSTGRESQL_BIN -D $POSTGRESQL_CONFIG_DIR
else
    # Start PostgreSQL
    echo "Starting PostgreSQL..."
    sudo -u postgres $POSTGRESQL_BIN -D $POSTGRESQL_CONFIG_DIR
fi

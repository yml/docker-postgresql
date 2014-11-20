# docker-postgresql

A Dockerfile that produces a container that will run [PostgreSQL][postgresql].

[postgresql]: http://www.postgresql.org/

## Container Creation / Running

The PostgreSQL server is configured to store data in `/data` inside the
container.  You can map the container's `/data` volume to a volume on the host
so the data becomes independant of the running container. 

This example uses `/tmp/postgresql` to store the PostgreSQL data, but you can
modify this to your needs.

If you set POSTGRESQL_USER_DB=database_name and POSTGRESQL_PROJECT_DB="project",
when the container runs it will create 2 new databases with the USER having
full ownership of it.

``` shell
$ docker build -t mypg_image --rm .
$ docker run -t \
             -p 127.0.0.1:5432:5432 \
             -v /tmp/postgresql:/data \
             -e POSTGRESQL_USER="super" \
             -e POSTGRESQL_USER_DB="super" \
             -e POSTGRESQL_PROJECT_DB="super" \
             -e POSTGRESQL_PASSWORD="$(pwgen -s -1 16)" \
             mypg_image
```


You can also specify a custom port to bind to on the host, a custom data
directory, and the superuser username and password.

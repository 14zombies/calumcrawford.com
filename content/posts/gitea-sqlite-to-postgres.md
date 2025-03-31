---
title: "Gitea database migration"
description: "Moving Gitea from SQLite to Postgresql"
date: "2025-03-14"
tags:
    - gitea
---

My Gitea instance was originally spun up using SQLite — as this was easiest at the time. Over the years I've tried several times to switch to PostgreSQL and been unsuccessful until now.

Most of the steps are taken from this [issue](https://github.com/go-gitea/gitea/issues/31820) on Github and the [Database Preparation](https://docs.gitea.com/next/installation/database-prep#postgresql) page of the Gitea docs. Before you proceed please read both and take onboard this nugget of wisdom. 
> "Switching DBs is always hard, no matter what application you are running." — [delvh](https://github.com/go-gitea/gitea/issues/31820#issuecomment-2284973449)

With that said make full backups and prepare to fail.


>[!Note]
>
>I'm running Gitea in a docker container using the rootless image, so the `app.ini` location maybe different. `/etc/gitea/app.ini` refers to the config Gitea is currently using.

## Instructions
Mount a volume shared between the Gitea container and Postgresql container. For ease I mounted it at `/opt/import` in both containers.

```yaml
version: '3.8'
services:
    git:
        image: gitea/gitea
        volumes:
            - "git_import:/opt/import"
        …
    db:
        image: postgres:16.4-alpine
        environment:
            POSTGRES_DB: gitea
            POSTGRES_USER: gitea
            POSTGRES_PASSWORD: itsasecret
        volumes:
            - "git_import:/opt/import"
        …
volumes:
    git_import:
        driver: local

```


Docker exec into the running Gitea container and execute `gitea doctor check --all --fix` and `gitea doctor recreate-table` to make sure the SQLite database is in a good starting condition. If you run into errors here **do not proceed** until you have fixed them.

Stop the Gitea container and copy the database file to `/opt/import`[^1]. 
I did this on the docker host

```console
$ cp /var/lib/docker/volumes/gitea_gitea_data/_data/gitea.db \
>    /var/lib/docker/volumes/gitea_git_import/_data/gitea.db
```

This step avoids accidentally working on a database that is in use.

Restart the Gitea container and run the following in the container to dump the current database to a file that Postgresql should be able to import.

```console
$ cd /opt/import
$ cp /etc/gitea/app.ini /opt/import/app.ini
```

Edit the path option of the database section in `/opt/import/app.ini` to point to `/opt/import/gitea.db`
```console
$ gitea --config /opt/import/app.ini dump \
>    --database postgres --skip-repository --skip-custom-dir \
>    --skip-attachment-data --skip-package-data --skip-index \
>    --file gitea-dump.zip
$ unzip gitea-dump.zip
```

Switch to the Postgres container and follow all the steps on [Database Preparation](https://docs.gitea.com/next/installation/database-prep#postgresql) for PostgreSQL

1. Edit `/var/lib/postgresql/data/postgresql.conf` make sure `password_encryption = scram-sha-256` in the file and not commented out.
2. Restart Postgres container.
3. Make sure the database role (user) exists 
    ```postgresql
    CREATE ROLE gitea WITH LOGIN PASSWORD 'itsasecret';
    ```
4. Create the database 
    ```postgresql
    CREATE DATABASE gitea WITH OWNER gitea TEMPLATE template0 ENCODING UTF8 LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8';
    ```
5. Make sure `/var/lib/postgresql/data/pg_hba.conf` has the following line `host    gitea    gitea    192.0.2.10/32    scram-sha-256` which has the format `CONNECTION_TYPE` `DATABASE_NAME` `USER` `ADDRESS` `METHOD` all of which should be documented in the file itself.
6. Restart Postgres container
7. Import the exported database.
    ```console
    $ cd /opt/import
    $ psql -U gitea
    ```

    ```postgresql
    \i gitea-db.sql
    ```

8. Wait for the import to complete.
9. Restart Postgres container

Switch back to the Gitea container
Edit `/opt/import/app.ini` with your new database settings.
```ini
[database]
DB_TYPE  = postgres
HOST     = db:5432
NAME     = gitea
USER     = gitea
PASSWD   = itsasecret 
SSL_MODE = disable
```

```console
$ gitea doctor --config /opt/import/app.ini check --all --fix
$ gitea doctor --config /opt/import/app.ini recreate-table
```

Edit `/etc/gitea/app.ini` with the same database configuration as above and add the following
```ini
[log]
LEVEL = Debug
```

Restart both containers and watch the Gitea startup logs while praying. 
Finally as is Gitea tradition, login to the Site Administration interface and 'Resynchronize pre-receive, update and post-receive hooks of all repositories.'

[^1]: I ran into permissions issues — due to the rootless image — a quick `chown -R 1000:1000 /var/lib/docker/volumes/git_import/_data` on the docker host system worked a treat.

---

date: 2021-11-23T23:59:49+0000
title: Docker Healthchecks for Spinning Up Local Stacks
slug: docker-healthchecks-for-spinning-up-local-stacks
tags:

- tech
- development
- microblog
- docker

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

I've used a few approaches in the past with "wait-for-it" style containers.

Realized there's some great features with healthchecks in Docker compose so I decided to try it out and it worked perfectly for Docker compose setup.

This can be a great way to add some container health checks in Docker Compose files, or directly in the Dockerfile itself.

```yaml
---
version: '3'

networks:
  backend:
  database:

volumes:
  mysql-data:

services:
  redis:
    image: redis
    ports:
      - 6379:6379
    networks:
      - backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 1s
      timeout: 3s
      retries: 30
  mysql:
    image: mysql:5.8
    env_file: ../env/.env # or use another path
    volumes:
      - mysq-data:/var/lib/mysql
      # This is the initialization path on first create
      # Anything under the directory will be run in order (so use sorted naming like 01_init.sql, 02_data.sql, etc)
      - ../db/myql/schema/:/docker-entrypoint-initdb.d
    ports:
      - 3306:3306
    networks:
      - database
    healthcheck:
      #test: "/etc/init.d/mysql status"  > didn't work
      # The environment variable here is loaded from the .env file in env_file
      test: mysqladmin ping -h 127.0.0.1 -u root --password=$$MYSQL_ROOT_PASSWORD
      interval: 1s
      timeout: 3s
      retries: 120

    ### example api service that now depends on both redis and mysql to be healthy before proceeding
    api:
    image: api:latest
    env_file: ../env/.env
    ports:
      - 3000:3000
    networks:
      - backend
      - database
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_healthy
```

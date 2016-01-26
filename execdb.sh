#!/bin/bash

# Utility script to shell into the mysql client

DATADIR=~/docker-data/docker-shared/mysql

docker rm -f `docker ps -a -q` 

docker run --name liferay-mysql \
	-v $DATADIR:/var/lib/mysql \
	-e MYSQL_ROOT_PASSWORD=W8woord -d mysql:latest

docker run -it --link liferay-mysql:mysql --rm mysql sh \
	-c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" \
	-P"$MYSQL_PORT_3306_TCP_PORT" -uroot \
	-p"W8woord"'

#!/bin/bash

# Start single server

LIFERAY_IMAGE=liferay-ee-sp14-dev-hotfix-14954-6210

LIFERAY_DATA_DIR=/opt/liferay-portal-6.2-ee-sp14/data # in container

DOCKER_BASE=~/docker-data
SHARED_BASE=$DOCKER_BASE/docker-shared
SHARED_STUFF_DIR=$SHARED_BASE/shared-stuff # for convenience
DOCUMENT_LIBRARY_DIR=$SHARED_BASE/liferay-dl
MYSQL_DATADIR=$SHARED_BASE/mysql
CONTAINER_DATA=$DOCKER_BASE/container-data

PERSIST_DIRS="hsql jackrabbit license lucene opensocial osgi"
SLEEP_TIME=2m

function checkip {
	if [ -z "$1" ]; then
		echo Error getting IP address, exiting
		docker rm -f `docker ps -a -q`
		exit 1
	fi
}

# clean start. Do not use IRL
docker rm -f `docker ps -a -q` 

docker run --name liferay-mysql \
	-v $MYSQL_DATADIR:/var/lib/mysql \
	-e MYSQL_ROOT_PASSWORD=W8woord -d mysql:latest
IPMYSQL=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' liferay-mysql`
checkip $IPMYSQL
echo mySQL running on $IPMYSQL

CONTAINER=liferay-dev

# stuff that should persists. Note: document_library is shared
for I in $PERSIST_DIRS; do
	mkdir -p $CONTAINER_DATA/$CONTAINER/$I
done

docker run -d \
	-e DB_IP=$IPMYSQL \
	-e DB_PORT=3306 \
	-e DB_USER=root \
	-e DB_PASSWORD=W8woord \
	-e CLUSTER_LINK_AUTODETECT_ADDRESS=$IPWEBSERVER \
	-e RUN_CMD=liferay \
	-v $DOCUMENT_LIBRARY_DIR:/mnt/document_library \
	-v $SHARED_STUFF_DIR:/mnt/shared_stuff \
	-v $CONTAINER_DATA/$CONTAINER/hsql:$LIFERAY_DATA_DIR/hsql \
	-v $CONTAINER_DATA/$CONTAINER/jackrabbit:$LIFERAY_DATA_DIR/jackrabbit \
	-v $CONTAINER_DATA/$CONTAINER/license:$LIFERAY_DATA_DIR/license \
	-v $CONTAINER_DATA/$CONTAINER/lucene:$LIFERAY_DATA_DIR/lucene \
	-v $CONTAINER_DATA/$CONTAINER/opensocial:$LIFERAY_DATA_DIR/opensocial \
	-v $CONTAINER_DATA/$CONTAINER/osgi:$LIFERAY_DATA_DIR/osgi \
	--name $CONTAINER \
	$LIFERAY_IMAGE \
	/run.sh

IPCONTAINER=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER`
checkip $IPCONTAINER
echo Liferay container $CONTAINER running on $IPCONTAINER

docker logs -f $CONTAINER

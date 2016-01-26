#!/bin/bash

# Start unicast cluster

# pick one
#CLUSTER_IMAGE=liferay-ee-sp8-standard-cluster-hotfix-15112-6210
CLUSTER_IMAGE=liferay-ee-sp8-gso-cluster-hotfix-15112-6210

# pick one
LIFERAY_DATA_DIR=/opt/liferay-portal-6.2-ee-sp8/data # in container
# LIFERAY_DATA_DIR=/opt/liferay-portal-6.2-ee-sp14/data # in container

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

docker run --name reference-nginx -d nginx
IPWEBSERVER=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' reference-nginx`
checkip $IPWEBSERVER
echo nginx running on $IPWEBSERVER

# =====================================================================================
CONTAINER=unicast1
echo Make container $CONTAINER

# stuff that should persists. Note: document_library is shared
for I in $PERSIST_DIRS; do
	mkdir -p $CONTAINER_DATA/$CONTAINER/$I
done

# unicast configuration
MY_IP=172.17.0.4
MY_PORT=7800
OTHER_IP=172.17.0.5
OTHER_PORT=7801

docker run -d \
	-e DB_IP=$IPMYSQL \
	-e DB_PORT=3306 \
	-e DB_USER=root \
	-e DB_PASSWORD=W8woord \
	-e CLUSTER_LINK_AUTODETECT_ADDRESS=$IPWEBSERVER \
	-e RUN_CMD=liferay \
	-e MY_IP=$MY_IP \
	-e MY_PORT=$MY_PORT \
	-e OTHER_IP=$OTHER_IP \
	-e OTHER_PORT=$OTHER_PORT \
	-v $DOCUMENT_LIBRARY_DIR:/mnt/document_library \
	-v $SHARED_STUFF_DIR:/mnt/shared_stuff \
	-v $CONTAINER_DATA/$CONTAINER/hsql:$LIFERAY_DATA_DIR/hsql \
	-v $CONTAINER_DATA/$CONTAINER/jackrabbit:$LIFERAY_DATA_DIR/jackrabbit \
	-v $CONTAINER_DATA/$CONTAINER/license:$LIFERAY_DATA_DIR/license \
	-v $CONTAINER_DATA/$CONTAINER/lucene:$LIFERAY_DATA_DIR/lucene \
	-v $CONTAINER_DATA/$CONTAINER/opensocial:$LIFERAY_DATA_DIR/opensocial \
	-v $CONTAINER_DATA/$CONTAINER/osgi:$LIFERAY_DATA_DIR/osgi \
	--name $CONTAINER \
	$CLUSTER_IMAGE \
	/run.sh

IPCONTAINER=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER`
checkip $IPCONTAINER
echo Liferay container $CONTAINER running on $IPCONTAINER

if [ "$MY_IP" != "$IPCONTAINER" ]; then
	echo Oops... Container IP should be $MY_IP but is $IPCONTAINER
	docker rm -f `docker ps -a -q` 
	exit 1
fi

echo Now sleep $SLEEP_TIME
sleep $SLEEP_TIME

# =====================================================================================
CONTAINER=unicast2
echo Make container $CONTAINER

# stuff that should persists. Note: document_library is shared
for I in $PERSIST_DIRS; do
	mkdir -p $CONTAINER_DATA/$CONTAINER/$I
done

# unicast configuration
MY_IP=172.17.0.5
MY_PORT=7801
OTHER_IP=172.17.0.4
OTHER_PORT=7800

docker run -d \
	-e DB_IP=$IPMYSQL \
	-e DB_PORT=3306 \
	-e DB_USER=root \
	-e DB_PASSWORD=W8woord \
	-e CLUSTER_LINK_AUTODETECT_ADDRESS=$IPWEBSERVER \
	-e RUN_CMD=liferay \
	-e MY_IP=$MY_IP \
	-e MY_PORT=$MY_PORT \
	-e OTHER_IP=$OTHER_IP \
	-e OTHER_PORT=$OTHER_PORT \
	-v $DOCUMENT_LIBRARY_DIR:/mnt/document_library \
	-v $SHARED_STUFF_DIR:/mnt/shared_stuff \
	-v $CONTAINER_DATA/$CONTAINER/hsql:$LIFERAY_DATA_DIR/hsql \
	-v $CONTAINER_DATA/$CONTAINER/jackrabbit:$LIFERAY_DATA_DIR/jackrabbit \
	-v $CONTAINER_DATA/$CONTAINER/license:$LIFERAY_DATA_DIR/license \
	-v $CONTAINER_DATA/$CONTAINER/lucene:$LIFERAY_DATA_DIR/lucene \
	-v $CONTAINER_DATA/$CONTAINER/opensocial:$LIFERAY_DATA_DIR/opensocial \
	-v $CONTAINER_DATA/$CONTAINER/osgi:$LIFERAY_DATA_DIR/osgi \
	--name $CONTAINER \
	$CLUSTER_IMAGE \
	/run.sh

IPCONTAINER=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER`
checkip $IPCONTAINER
echo Liferay container $CONTAINER running on $IPCONTAINER

if [ "$MY_IP" != "$IPCONTAINER" ]; then
	echo Oops... Container IP should be $MY_IP but is $IPCONTAINER
	docker rm -f `docker ps -a -q` 
	exit 1
fi

docker ps

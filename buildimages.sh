#!/bin/bash

# Wrapper script to build Java 7 and a few Liferay EE Docker images.
# Use this only as a sample, your mileage WILL vary unless you have
# the Liferay EE zips in the exact same versions. You will also need a
# mysql image, setup will be done later.

# This setup was created as a POC to show that Lucene indexing will
# fail across the cluster when unicast is not setup correctly.

BASEDIR=~/bin/docker-setups
DOWNLOADDIR=~/Downloads/liferay-6.2
DATADIR=~/Desktop/docker-data

mkdir -p $DATADIR
mkdir -p $DATADIR/container-data
mkdir -p $DATADIR/container-shared
mkdir -p $DATADIR/container-shared/liferay-dl
mkdir -p $DATADIR/container-shared/mysql
mkdir -p $DATADIR/docker-shared/shared-stuff

echo Copy in SP8 version of the patching tool, including patches
cp -r /opt/liferay-6.2/liferay-portal-6.2-ee-sp8/patching-tool \
	$DATADIR/docker-shared/shared-stuff || exit 1
cd $DATADIR/docker-shared/shared-stuff || exit 1
mv patching-tool sp8-patching-tool || exit 1
cp $DOWNLOADDIR/liferay-hotfix-15112-6210.zip sp8-patching-tool patches || exit 1

echo Build Java 7 image
cd $BASEDIR/java
docker build -t java7 .

echo Build Liferay SP14 image
cd $BASEDIR/liferay-ee-sp14
cp $DOWNLOADDIR/liferay-portal-tomcat-6.2-ee-sp14-20151105114451508.zip . || exit 1
cp "$DOWNLOADDIR/Ehcache Cluster EE.lpkg" . || exit 1
docker build -t liferay-ee-sp14 .
rm ./liferay-portal-tomcat-6.2-ee-sp14-20151105114451508.zip || exit 1
rm "./Ehcache Cluster EE.lpkg" || exit 1

echo Build Liferay SP8 image
cd $BASEDIR/liferay-ee-sp8
cp $DOWNLOADDIR/liferay-portal-tomcat-6.2-ee-sp8-20140904111637931.zip . || exit 1
cp "$DOWNLOADDIR/Ehcache Cluster EE.lpkg" . || exit 1
docker build -t liferay-ee-sp8 .
rm ./liferay-portal-tomcat-6.2-ee-sp8-20140904111637931.zip || exit 1
rm "./Ehcache Cluster EE.lpkg" || exit 1

echo Build Liferay SP14 multicast cluster
cd $BASEDIR/liferay-sp14-standard-cluster
docker build -t liferay-ee-sp14-standard-cluster .

echo Build Liferay SP14 unicast cluster
cd $BASEDIR/liferay-sp14-gso-cluster
docker build -t liferay-ee-sp14-gso-cluster .

echo Build Liferay SP8 multicast cluster
cd $BASEDIR/liferay-sp8-standard-cluster
docker build -t liferay-ee-sp8-standard-cluster .

echo Build Liferay SP8 unicast cluster
cd $BASEDIR/liferay-sp8-gso-cluster
docker build -t liferay-ee-sp8-gso-cluster .

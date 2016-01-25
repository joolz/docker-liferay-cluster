#!/bin/bash

LR_DIR=/opt/liferay-portal-6.2-ee-sp8
TOMCAT_DIR=$LR_DIR/tomcat-7.0.42
PE=$LR_DIR/portal-ext.properties
TCP=$TOMCAT_DIR/webapps/ROOT/WEB-INF/classes/myehcache/tcp.xml

if [ -n "$DB_IP" ] && \
	[ -n "$DB_PORT" ] && \
	[ -n "$DB_USER" ] && \
	[ -n "$DB_PASSWORD" ] && \
	[ -n "$CLUSTER_LINK_AUTODETECT_ADDRESS" ] && \
	[ -n "$MY_IP" ] && \
	[ -n "$MY_PORT" ] && \
	[ -n "$OTHER_IP" ] && \
	[ -n "$OTHER_PORT" ]; then

	echo Got DB_IP $DB_IP
	echo Got DB_PORT $DB_PORT
	echo Got DB_USER $DB_USER
	echo Got DB_PASSWORD $DB_PASSWORD
	echo Got CLUSTER_LINK_AUTODETECT_ADDRESS $CLUSTER_LINK_AUTODETECT_ADDRESS
	echo Got MY_IP $MY_IP
	echo Got MY_PORT $MY_PORT
	echo Got OTHER_IP $OTHER_IP
	echo Got OTHER_PORT $OTHER_PORT
	
	sed -i -e "s/DB_IP/$DB_IP/" $PE
	sed -i -e "s/DB_PORT/$DB_PORT/" $PE
	sed -i -e "s/DB_USER/$DB_USER/" $PE
	sed -i -e "s/DB_PASSWORD/$DB_PASSWORD/" $PE
	sed -i -e "s/CLUSTER_LINK_AUTODETECT_ADDRESS/$CLUSTER_LINK_AUTODETECT_ADDRESS/" $PE

	sed -i -e "s/MY_IP/$MY_IP/" $TCP
	sed -i -e "s/MY_PORT/$MY_PORT/" $TCP
	sed -i -e "s/OTHER_IP/$OTHER_IP/" $TCP
	sed -i -e "s/OTHER_PORT/$OTHER_PORT/" $TCP

	# we need to be able to access the container while Liferay isn't
	# running to apply hotfixes
	if [ "$RUN_CMD" == "liferay" ]; then
		$TOMCAT_DIR/bin/catalina.sh run
	fi

else
	echo Not all required parameters are supplied
	exit 1

fi

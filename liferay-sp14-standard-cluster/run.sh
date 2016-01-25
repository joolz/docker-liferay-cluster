#!/bin/bash

LR_DIR=/opt/liferay-portal-6.2-ee-sp14
TOMCAT_DIR=$LR_DIR/tomcat-7.0.62
PE=$LR_DIR/portal-ext.properties

if [ -n "$DB_IP" ] && \
	[ -n "$DB_PORT" ] && \
	[ -n "$DB_USER" ] && \
	[ -n "$DB_PASSWORD" ]; then

	echo Got DB_IP $DB_IP
	echo Got DB_PORT $DB_PORT
	echo Got DB_USER $DB_USER
	echo Got DB_PASSWORD $DB_PASSWORD
	
	sed -i -e "s/DB_IP/$DB_IP/" $PE
	sed -i -e "s/DB_PORT/$DB_PORT/" $PE
	sed -i -e "s/DB_USER/$DB_USER/" $PE
	sed -i -e "s/DB_PASSWORD/$DB_PASSWORD/" $PE

	# we need to be able to access the container while Liferay isn't
	# running to apply hotfixes
	if [ "$RUN_CMD" == "liferay" ]; then
		$TOMCAT_DIR/bin/catalina.sh run
	else
		bash
	fi

else
	echo Not all required parameters are supplied
	exit 1

fi

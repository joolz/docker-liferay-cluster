# create a Liferay EE GSO clustered configuration

FROM liferay-ee-sp8
MAINTAINER Joolz <jal@ou.nl>

COPY portal-ext.properties /opt/liferay-portal-6.2-ee-sp8
RUN mkdir /opt/liferay-portal-6.2-ee-sp8/tomcat-7.0.42/webapps/ROOT/WEB-INF/classes/myehcache
COPY tcp.xml /opt/liferay-portal-6.2-ee-sp8/tomcat-7.0.42/webapps/ROOT/WEB-INF/classes/myehcache

# copy in startup script for containers

COPY run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh

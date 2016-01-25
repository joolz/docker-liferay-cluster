# create a Liferay EE standard clustered configuration

FROM liferay-ee-sp8
MAINTAINER Joolz <jal@ou.nl>

COPY portal-ext.properties /opt/liferay-portal-6.2-ee-sp8

# copy in startup script for containers

COPY run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh

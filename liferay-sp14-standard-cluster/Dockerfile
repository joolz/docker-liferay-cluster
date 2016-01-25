# create a Liferay EE standard clustered configuration

FROM liferay-ee-sp14
MAINTAINER Joolz <jal@ou.nl>

COPY portal-ext.properties /opt/liferay-portal-6.2-ee-sp14

# copy in startup script for containers

COPY run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh

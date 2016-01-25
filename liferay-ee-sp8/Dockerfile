# Liferay EE with cluster software

FROM java7
MAINTAINER Joolz <jal@ou.nl>

# install liferay. lr_temp to have unzip find the file with a wildcard

RUN mkdir lr_temp
COPY liferay-portal-tomcat-6.2-ee-sp8-20140904111637931.zip /lr_temp/
RUN unzip lr_temp/*.zip -d /opt && rm -rf /lr_temp
RUN mkdir /opt/liferay-portal-6.2-ee-sp8/deploy
COPY portal-setup-wizard.properties /opt/liferay-portal-6.2-ee-sp8
COPY license*.xml /opt/liferay-portal-6.2-ee-sp8/deploy/
COPY *.lpkg /opt/liferay-portal-6.2-ee-sp8/deploy/

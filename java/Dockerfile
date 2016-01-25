# create a Liferay EE docker image

FROM ubuntu
MAINTAINER Joolz <jal@ou.nl>

# update system. Note: must be a oneliner

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get autoremove -y

# add extra software

RUN apt-get install -y unzip telnet vim software-properties-common

# install java 7
# https://shameerarathnayaka.wordpress.com/2015/07/19/how-to-install-oracle-java-8-7-on-ubuntu-based-image/

RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer

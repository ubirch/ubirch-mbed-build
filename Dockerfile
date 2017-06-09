FROM ubirch/arm-build:latest
MAINTAINER Falko Zurell <falko.zurell@ubirch.com>

LABEL description="uBirch ARM/NXP build container"
RUN apt-get update
RUN apt-get install python-pip -y
RUN apt-get install mercurial -y
RUN pip install mbed-cli
WORKDIR /opt
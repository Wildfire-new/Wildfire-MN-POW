FROM debian:stretch
LABEL maintainer="Wildfire Developers <dev@wildfire.org>"
LABEL description="Dockerised WildfireCore, built from Travis"

RUN apt-get update && apt-get -y upgrade && apt-get clean && rm -fr /var/cache/apt/*

COPY bin/* /usr/bin/

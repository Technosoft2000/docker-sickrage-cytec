FROM ubuntu:16.04
MAINTAINER Technosoft2000 <technosoft2000@gmx.net>

# Set basic environment settings
ENV SR_HOME=/sickrage
ENV SYNO_VOLUME=/volume1

# Set the needed applications
ENV APTLIST="git-core python python-cheetah python-openssl"

# Set the locale
RUN apt-get update -q && apt-get install language-pack-de-base -qy
ENV LANG=de_DE.UTF-8 LANGUAGE=de_DE:de LC_ALL=de_DE.UTF-8
RUN update-locale && locale-gen de_DE.UTF-8

# Set the timezone 
# HINT: set this environment variable to true to set timezone on container startup
ENV SET_CONTAINER_TIMEZONE false
# Default container timezone as found under the directory /usr/share/zoneinfo/
ENV CONTAINER_TIMEZONE UTC

# Create Snyology NAS /volume1 folders 
# to easily provide the same corresponding host directories at SickRage
RUN mkdir -p $SYNO_VOLUME/downloads && \
    mkdir -p $SYNO_VOLUME/video && \
    mkdir -p $SYNO_VOLUME/certificates

# Create SickRage folder structure
RUN mkdir -p $SR_HOME/app && \
    mkdir -p $SR_HOME/config && \
    mkdir -p $SR_HOME/data

WORKDIR $SR_HOME/app

# Install the packages required for SickRage
RUN apt-get install $APTLIST -qy

# Clean up APT when done.
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#start.sh will download the latest version of SickRage and run it.
ADD ./set_timezone.sh $SR_HOME/set_timezone.sh
ADD ./config.sh $SR_HOME/config.sh
ADD ./start.sh $SR_HOME/start.sh
RUN chmod u+x  $SR_HOME/start.sh

# Set volumes for the SickRage folder structure
VOLUME $SR_HOME/config $SR_HOME/data $SYNO_VOLUME/downloads $SYNO_VOLUME/video $SYNO_VOLUME/certificates

# Expose ports
EXPOSE 8081

# Start SickRage-cytec
CMD $SR_HOME/start.sh


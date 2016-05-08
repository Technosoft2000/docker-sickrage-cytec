FROM ubuntu:16.04
MAINTAINER Technosoft2000 <technosoft2000@gmx.net>

# Set basic environment settings
ENV SR_HOME=/sickrage

# Set the needed applications
ENV APTLIST="git-core python python-cheetah"

# Set the locale
RUN apt-get update -q && apt-get install language-pack-de-base -qy
ENV LANG=de_DE.UTF-8 LANGUAGE=de_DE:de LC_ALL=de_DE.UTF-8
RUN update-locale && locale-gen de_DE.UTF-8

# Create Snyology NAS /volume1 folder 
# to easily provide the same corresponding host directory at SickRage
RUN mkdir /volume1

# Create SickRage folder structure
RUN mkdir -p /$SR_HOME/app && \
    mkdir -p /$SR_HOME/config && \
    mkdir -p /$SR_HOME/data

WORKDIR /$SR_HOME/app

# Install the packages required for SickRage
RUN apt-get install $APTLIST -qy && apt-get clean -y

#start.sh will download the latest version of SickRage and run it.
ADD ./config.sh /$SR_HOME/config.sh
RUN chmod u+x  /$SR_HOME/config.sh
ADD ./start.sh /$SR_HOME/start.sh
RUN chmod u+x  /$SR_HOME/start.sh

# Set volumes for the SickRage folder structure
VOLUME ["/sickrage/config", "/sickrage/data", "/volume1"]

# Expose ports
EXPOSE 8081

# Start SickRage-cytec
CMD ["/sickrage/start.sh"]



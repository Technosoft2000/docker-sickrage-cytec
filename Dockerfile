FROM ubuntu:16.04
MAINTAINER Technosoft2000 <technosoft2000@gmx.net>

# Set basic environment settings
# - SR_HOME: SickRage Home directory
# - SR_REPO, SR_BRANCH: SickRage GitHub repository and related branch
# - SYNO_VOLUME: Snyology NAS volume main directory
# - APTLIST: the needed applications for installation
# - LANG, LANGUAGE, LC_ALL: language dependent settings (Default: de_DE.UTF-8)
# - SET_CONTAINER_TIMEZONE: set this environment variable to true to set timezone on container startup
# - CONTAINER_TIMEZONE: UTC, Default container timezone as found under the directory /usr/share/zoneinfo/
ENV SR_HOME=/sickrage \
    SR_REPO=https://github.com/cytec/SickRage.git SR_BRANCH=master \
    SYNO_VOLUME=/volume1 \
    APTLIST="git-core python python-cheetah python-openssl gosu" \
    LANG=de_DE.UTF-8 LANGUAGE=de_DE:de LC_ALL=de_DE.UTF-8 \
    SET_CONTAINER_TIMEZONE=false \
    CONTAINER_TIMEZONE=UTC

# 1. Update Ubuntu packages
# 2. Install the packages required for SickRage
# 3. Install locale packages and set the locale
# 4. Create Snyology NAS /volume1 folders 
#    to easily provide the same corresponding host directories at SickRage
# 5. Create SickRage folder structure
# 6. Clean up APT when done.
RUN apt-get update -q && \
    apt-get install $APTLIST -qy && \
    apt-get install language-pack-de-base -qy && \
    update-locale && locale-gen $LANG && \
    mkdir -p $SYNO_VOLUME/downloads && \
    mkdir -p $SYNO_VOLUME/video && \
    mkdir -p $SYNO_VOLUME/certificates && \
    mkdir -p $SR_HOME/app && \
    mkdir -p $SR_HOME/config && \
    mkdir -p $SR_HOME/data && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set the working directory for SickRage
WORKDIR $SR_HOME/app

#start.sh will download the latest version of SickRage and run it.
ADD ./set_timezone.sh $SR_HOME/set_timezone.sh
ADD ./config.sh $SR_HOME/config.sh
ADD ./start.sh $SR_HOME/start.sh
RUN chmod u+x $SR_HOME/start.sh

# Set volumes for the SickRage folder structure
VOLUME $SR_HOME/config $SR_HOME/data $SYNO_VOLUME/downloads $SYNO_VOLUME/video $SYNO_VOLUME/certificates

# Expose ports
EXPOSE 8081

# Start SickRage-cytec
ENTRYPOINT $SR_HOME/start.sh


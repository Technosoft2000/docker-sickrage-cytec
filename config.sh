#!/usr/bin/env bash

PUID=${PUID:=15000}
PUSER=${PUSER:=sickrage}
PGID=${PGID:=15000}
PGROUP=${PGROUP:=sickrage}

#Create internal mediadepot user (which will be mapped to external user and used to run the process)
addgroup --gid $PGID $PGROUP
adduser --shell /bin/bash --no-create-home --uid $PUID --ingroup $PGROUP --disabled-password --gecos "" $PUSER


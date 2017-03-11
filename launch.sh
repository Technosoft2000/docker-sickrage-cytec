#!/bin/bash

# launch the APP
echo "[INFO] Launching $APP_NAME ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $APP_HOME/app/SickBeard.py --quiet --nolaunch --datadir $APP_HOME/data --config $APP_HOME/config/sickbeard.ini"

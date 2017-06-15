#!/bin/bash

# launch the APP
echo "[INFO] Launching $APP_NAME ..."

# use option '--quiet' to don't redirect the log output on the console:
#   gosu $PUSER:$PGROUP bash -c "/usr/bin/python $APP_HOME/app/SickBeard.py --quiet --nolaunch --datadir $APP_HOME/data --config $APP_HOME/config/sickbeard.ini"
#
# without this option the log could be checked with 'docker logs' 
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $APP_HOME/app/SickBeard.py --nolaunch --datadir $APP_HOME/data --config $APP_HOME/config/sickbeard.ini"

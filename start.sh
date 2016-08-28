#!/bin/bash

#show the info text
cat $SR_HOME/info.txt

#run the default config script
source $SR_HOME/config.sh

#chown the SickRage directory by the new user
echo "[INFO] Change the ownership of $SR_HOME (including subfolders) to $PUSER:$PGROUP"
chown $PUSER:$PGROUP -R $SR_HOME

# download the latest version of the SickRage-cytec release
# see at https://github.com/cytec/SickRage
echo "[INFO] Checkout the latest SickRage version ..."
[[ ! -d $SR_HOME/app/.git ]] && gosu $PUSER:$PGROUP bash -c "git clone -b $SR_BRANCH $SR_REPO $SR_HOME/app"

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
        echo "[INFO] Autoupdate is active, try to pull the latest sources ..."
	# update the application
	cd $SR_HOME/app/ && gosu $PUSER:$PGROUP bash -c "git pull"
fi

# run SickRage
echo "[INFO] Launching SickRage ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $SR_HOME/app/SickBeard.py --quiet --nolaunch --datadir $SR_HOME/data --config $SR_HOME/config/sickbeard.ini"

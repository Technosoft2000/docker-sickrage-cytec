#!/bin/bash

#run the default config script
source $SR_HOME/config.sh

#chown the SickRage directory by the new user
chown $PUSER:$PGROUP -R $SR_HOME

# download the latest version of the SickRage-cytec release
# see at https://github.com/cytec/SickRage
[[ ! -d $SR_HOME/app/.git ]] && gosu $PUSER:$PGROUP bash -c "git clone -b $SR_BRANCH $SR_REPO $SR_HOME/app"

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
	# update the application
	cd $SR_HOME/app/ && gosu $PUSER:$PGROUP bash -c "git pull"
fi

# run SickRage
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $SR_HOME/app/SickBeard.py --quiet --nolaunch --datadir $SR_HOME/data --config $SR_HOME/config/sickbeard.ini"


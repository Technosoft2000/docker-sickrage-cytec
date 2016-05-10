#!/usr/bin/env bash

#run the default config script
source $SR_HOME/config.sh

#chown the SickRage directory by the new user
chown $PUSER:$PGROUP -R $SR_HOME

# download the latest version of the SickRage-cytec release
# see at https://github.com/cytec/SickRage
[[ ! -d $SR_HOME/app/.git ]] && su -c "git clone https://github.com/cytec/SickRage.git $SR_HOME/app" $PUSER

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
	# update the application
	cd $SR_HOME/app/ && su -c "git pull" $PUSER
fi

# run SickRage
su -c "/usr/bin/python $SR_HOME/app/SickBeard.py --nolaunch --datadir $SR_HOME/data --config $SR_HOME/config/sickbeard.ini" $PUSER


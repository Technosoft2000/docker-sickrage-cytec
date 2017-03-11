#!/bin/bash

# get or update all parts for the APP

# download the latest version of the SickRage-cytec
# see at https://github.com/cytec/SickRage
source /init/checkout.sh "$APP_NAME" "$APP_BRANCH" "$APP_REPO" "$APP_HOME/app"

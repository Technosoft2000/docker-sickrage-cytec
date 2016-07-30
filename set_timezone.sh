#!/bin/bash

# Set the timezone.
if [ "$SET_CONTAINER_TIMEZONE" = "true" ]; then
    ln -sf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    echo "Container timezone set to: $CONTAINER_TIMEZONE"
else
    echo "Container timezone not modified"
fi


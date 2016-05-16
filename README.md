# docker-sickrage-cytec
Docker image for SickRage-cytec fork, based on docker image of Ubuntu 16.04

## Usage ##

__Create the container:__
```
docker create --name=sickrage-cytec \
-v <config directory>:/sickrage/config \
-v <data directory>:/sickrage/data \
-v <tv downloads directory>:/volume1/downloads \
-v <tv series directory>:/volume1/video \
[-v /volume1/certificates:/volume1/certificates \]
[-v /etc/localtime:/etc/localtime:ro \]
[-e SET_CONTAINER_TIMEZONE=true \]
[-e CONTAINER_TIMEZONE=<container timezone value> \]
[-e PGID=<group ID (gid)> -e PUID=<user ID (uid)> \]
-p <HTTP port>:8081 \
technosoft2000/sickrage-cytec
```

__Example:__
```
docker create --name=sickrage-cytec \
-v /opt/docker/sickrage/config:/sickrage/config \
-v /opt/docker/sickrage/data:/sickrage/data \
-v /volume1/downloads:/volume1/downloads \
-v /volume1/video:/volume1/video \
-v /etc/localtime:/etc/localtime:ro \
-e PGID=1001 -e PUID=1001 \
-p 8081:8081 \
technosoft2000/sickrage-cytec
```

*or*

```
docker create --name=sickrage-cytec \
-v /opt/docker/sickrage/config:/sickrage/config \
-v /opt/docker/sickrage/data:/sickrage/data \
-v /volume1/downloads:/volume1/downloads \
-v /volume1/video:/volume1/video \
-e SET_CONTAINER_TIMEZONE=true \
-e CONTAINER_TIMEZONE=Europe/Berlin \
-e PGID=1001 -e PUID=1001 \
-p 8081:8081 \
technosoft2000/sickrage-cytec
```

__Start the container:__
```
docker start sickrage-cytec
```

## Parameters ##
* `-p 8081` - http port for the web user interface
* `-v /sickrage/config` - local path for sickrage config files
* `-v /sickrage/data` - local path for sickrage data files (cache, database, ...)
* `-v /volume1/downloads` - the folder where your download client puts the completed TV downloads
* `-v /volume1/video` - the target folder where the tv series will be placed
* `-v /volume1/certificates` - the target folder of the SSL/TLS certificate files
* `-v /etc/localhost` - for timesync - __optional__
* `-e SET_CONTAINER_TIMEZONE` - set it to `true` if the specified `CONTAINER_TIMEZONE` should be used - __optional__ 
* `-e CONTAINER_TIMEZONE` - container timezone as found under the directory `/usr/share/zoneinfo/` - __optional__
* `-e PGID` for GroupID - see below for explanation - __optional__
* `-e PUID` for UserID - see below for explanation - __optional__

### Container Timezone

In the case of the Synology NAS it is not possible to map `/etc/localtime` for timesync, and for this and similar case
set `SET_CONTAINER_TIMEZONE` to `true` and specify with `CONTAINER_TIMEZONE` which timezone should be used.
The possible container timezones can be found under the directory `/usr/share/zoneinfo/`.
Examples:
* localtime
* UTC
* Europe\Berlin
* Europe\Vienna
* America\New_York

## User / Group Identifiers ##
Sometimes when using data volumes (-v flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user PUID and group PGID. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance PUID=1001 and PGID=1001. To find yours use id user as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Additional ##
Shell access whilst the container is running: `docker exec -it sickrage-cytec /bin/bash`
Upgrade to the latest version: `docker restart sickrage-cytec`
To monitor the logs of the container in realtime: `docker logs -f sickrage-cytec`

---

## For Synology NAS users ##

Login into the DSM Web Management
* Open the Control Panel
* Control _Panel_ > _Privilege_ > _Group_ and create a new one with the name 'docker'
* add the permissions for the directories 'downloads', 'video' and so on
* disallow the permissons to use the applications
* Control _Panel_ > _Privilege_ > _User_ and create a new on with name 'docker' and assign this user to the group 'docker'

Connect with SSH to your NAS
* create a 'docker' directory on your volume (if such doesn't exist)
```
mkdir -p /volume1/docker/
chown root:root /volume1/docker/
```

* create a 'sickrage' directory
```
cd /volume1/docker#
mkdir apps
chown docker:docker apps
cd apps
mkdir -p sickrage/config
mkdir -p sickrage/data
chown -R docker:docker sickrage
```

* get your Docker User ID and Group ID of your previously created user and group
```
id docker

uid=1029(docker) gid=100(users) groups=100(users),65539(docker)
```

* get the Docker image
```
docker pull technosoft2000/sickrage-cytec
```

* create a Docker container (take care regarding the user ID and group ID, change timezone and port as needed)
```
docker create --name=sickrage-cytec \
-v /volume1/docker/apps/sickrage/config:/sickrage/config \
-v /volume1/docker/apps/sickrage/data:/sickrage/data \
-v /volume1/downloads:/volume1/downloads \
-v /volume1/video:/volume1/video \
-e SET_CONTAINER_TIMEZONE=true \
-e CONTAINER_TIMEZONE=Europe/Berlin \
-e PGID=65539 -e PUID=1029 \
-p 9091:8081 \
technosoft2000/sickrage-cytec
```

* check if the Docker container was created successfully
```
docker ps -a

CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS               NAMES
0b33c177b6ae        technosoft2000/sickrage-cytec   "/sickrage/start.sh"   8 seconds ago       Created 
```

* start the Docker container
```
docker start sickrage-cytec
```

* analyze the log (stop it with CTRL+C)
```
docker logs -f sickrage-cytec

Adding group 'sickrage' (GID 65539) ...
Done.
Adding user 'sickrage' ...
Adding new user 'sickrage' (1029) with group 'sickrage' ...
Not creating home directory `/home/sickrage'.
Current default time zone: 'Europe/Berlin'
Local time is now:      Mon May 16 13:56:18 CEST 2016.
Universal Time is now:  Mon May 16 11:56:18 UTC 2016.
Container timezone set to: Europe/Berlin
Klone nach '/sickrage/app' ...
Already up-to-date.
21:31:04 INFO::MAIN :: Checking for shows with tvrage id's, since tvrage is gone
21:31:04 INFO::MAIN :: New API generated
21:31:04 INFO::TORNADO :: Starting SickRage on http://0.0.0.0:8081/
21:31:04 INFO::MAIN :: Checking for scene exception updates for theTVDB
21:31:04 WARNING::MAIN :: Check scene exceptions update failed. Unable to update from: http://sickragetv.github.io/sb_tvdb_scene_excepti
ons/exceptions.txt
21:31:04 INFO::MAIN :: Checking for XEM scene exception updates for theTVDB
21:31:05 INFO::MAIN :: Checking for scene exception updates for AniDB
21:31:05 INFO::MAIN :: Building internal name cache for all shows
21:31:05 INFO::MAIN :: Updating timezone info with new one: zoneinfo-2015g.tar.gz
```


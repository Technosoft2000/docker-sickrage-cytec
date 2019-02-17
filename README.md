# SickRage
![](https://sickrage.github.io/images/logo.png)

[![Docker Stars](https://img.shields.io/docker/stars/technosoft2000/sickrage-cytec.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/technosoft2000/sickrage-cytec.svg)]()
[![](https://images.microbadger.com/badges/image/technosoft2000/sickrage-cytec.svg)](http://microbadger.com/images/technosoft2000/sickrage-cytec "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/technosoft2000/sickrage-cytec.svg)](http://microbadger.com/images/technosoft2000/sickrage-cytec "Get your own version badge on microbadger.com")

## SickRage - The automated TV Shows download manager ##

SickRage is an automatic Video Library Manager for TV Shows.
It watches for new episodes of your favorite shows, and when they are posted it does its magic: automatic torrent/nzb searching, downloading, and processing at the qualities you want.

## Updates ##

**2019-02-17 - v1.2.0**

 * upgrade to latest base image [technosoft2000/alpine-base:3.9-1](https://hub.docker.com/r/technosoft2000/alpine-base/)

For previous changes see at [full changelog](CHANGELOG.md).

## Features ##

 * running SickRage under its own user (not root)
 * changing of the UID and GID for the SickRage user
 * support of SSL / HTTPS encryption via __LibreSSL__

**Modifications on [SickRage](https://sickrage.github.io/) by cytec**

 * fixes to detect German releases correctly
 * added special support for German Airdates

## Usage ##

__Create the container:__
```
docker create --name=sickrage-cytec --restart=always \
-v <config directory>:/sickrage/config \
-v <data directory>:/sickrage/data \
-v <tv downloads directory>:/volume1/downloads \
-v <tv series directory>:/volume1/video \
[-v <path to certificates>:/volume1/certificates \]
[-v /etc/localtime:/etc/localtime:ro \]
[-e APP_REPO=https://github.com/cytec/SickRage.git \]
[-e APP_BRANCH=master \]
[-e SET_CONTAINER_TIMEZONE=true \]
[-e CONTAINER_TIMEZONE=<container timezone value> \]
[-e PGID=<group ID (gid)> -e PUID=<user ID (uid)> \]
-p <HTTP port>:8081 \
technosoft2000/sickrage-cytec
```

__Example:__
```
docker create --name=sickrage-cytec --restart=always \
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
docker create --name=sickrage-cytec --restart=always \
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

### Introduction ###
The parameters are split into two parts which are separated via colon.
The left side describes the host and the right side the container. 
For example a port definition looks like this ```-p external:internal``` and defines the port mapping from internal (the container) to external (the host).
So ```-p 8080:80``` would expose port __80__ from inside the container to be accessible from the host's IP on port __8080__.
Accessing http://'host':8080 (e.g. http://192.168.0.10:8080) would then show you what's running **INSIDE** the container on port __80__.

### Details ###
* `-p 8081` - http port for the web user interface
* `-v /sickrage/config` - local path for sickrage config files
* `-v /sickrage/data` - local path for sickrage data files (cache, database, ...)
* `-v /volume1/downloads` - the folder where your download client puts the completed TV downloads
* `-v /volume1/video` - the target folder where the tv series will be placed
* `-v /volume1/certificates` - the target folder of the SSL/TLS certificate files
* `-v /etc/localhost` - for timesync - __optional__
* `-e APP_REPO` - set it to the SickRage GitHub repository; by default it uses https://github.com/cytec/SickRage.git - __optional__
* `-e APP_BRANCH` - set which SickRage GitHub repository branch you want to use, __master__ (default branch) or __develop__ - __optional__
* `-e SET_CONTAINER_TIMEZONE` - set it to `true` if the specified `CONTAINER_TIMEZONE` should be used - __optional__ 
* `-e CONTAINER_TIMEZONE` - container timezone as found under the directory `/usr/share/zoneinfo/` - __optional__
* `-e PGID` for GroupID - see below for explanation - __optional__
* `-e PUID` for UserID - see below for explanation - __optional__

### Container Timezone ###

In the case of the Synology NAS it is not possible to map `/etc/localtime` for timesync, and for this and similar case
set `SET_CONTAINER_TIMEZONE` to `true` and specify with `CONTAINER_TIMEZONE` which timezone should be used.
The possible container timezones can be found under the directory `/usr/share/zoneinfo/`.

Examples:

 * ```UTC``` - __this is the default value if no value is set__
 * ```Europe/Berlin```
 * ```Europe/Vienna```
 * ```America/New_York```
 * ...

__Don't use the value__ `localtime` because it results into: `failed to access '/etc/localtime': Too many levels of symbolic links`

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
* after sucessful connection change to the root account via
```
sudo -i
```
or
```
sudo su -
```
for the password use the same one which was used for the SSH authentication.

* create a 'docker' directory on your volume (if such doesn't exist)
```
mkdir -p /volume1/docker/
chown root:root /volume1/docker/
```

* create a 'sickrage' directory
```
cd /volume1/docker
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
docker create --name=sickrage-cytec --restart=always \
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
        ,----,                                   
      ,/   .`|                                   
    ,`   .'  : .--.--.        ,----,        ,-.  
  ;    ;     //  /    '.    .'   .' \   ,--/ /|  
.'___,/    ,'|  :  /`. /  ,----,'    |,--. :/ |  
|    :     | ;  |  |--`   |    :  .  ;:  : ' /   
;    |.';  ; |  :  ;_     ;    |.'  / |  '  /    
`----'  |  |  \  \    `.  `----'/  ;  '  |  :    
    '   :  ;   `----.   \   /  ;  /   |  |   \   
    |   |  '   __ \  \  |  ;  /  /-,  '  : |. \  
    '   :  |  /  /`--'  / /  /  /.`|  |  | ' \ \ 
    ;   |.'  '--'.     /./__;      :  '  : |--'  
    '---'      `--'---' |   :    .'   ;  |,'     
                        ;   | .'      '--'       
                        `---'                    
      PRESENTS ANOTHER AWESOME DOCKER IMAGE
      ~~~~~  SickRage Cytec-Edition   ~~~~~
[INFO] Docker image version: 1.2.0
[INFO] Alpine Linux version: 3.9.0
[INFO] Create group sickrage with id 65539
[INFO] Create user sickrage with id 1029
[INFO] Current active timezone is UTC
Sun Feb 17 15:07:04 CET 2019
[INFO] Container timezone is changed to: Europe/Vienna
[INFO] Change the ownership of /sickrage (including subfolders) to sickrage:sickrage
[INFO] Current git version is:
git version 2.20.1
[INFO] Checkout the latest SickRage-Cytec version ...
[INFO] ... git clone -b develop --single-branch https://github.com/cytec/SickRage.git /sickrage/app -v
Cloning into '/sickrage/app'...
POST git-upload-pack (189 bytes)
```

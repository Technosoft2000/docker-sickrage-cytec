# docker-sickrage-cytec
Docker image for SickRage-cytec fork, based on docker image of Ubuntu 16.04

## Usage ##

__Create the container:__
```
docker create --name=sickrage-cytec \
-v <config directory>:/sickrage/config \
-v <data directory>:/sickrage/data \
[-v /volume1:/volume1 \] 
[-v /etc/localtime:/etc/localtime:ro \]
[-e PGID=<group ID (gid)> -e PUID=<user ID (uid)> \]
-p <HTTP port>:8081 \
technosoft2000/sickrage-cytec
```
__Example:__
```
docker create --name=sickrage-cytec \
-v /opt/docker/sickrage/config:/sickrage/config \
-v /opt/docker/sickrage/data:/sickrage/data \
-v /volume1:/volume1 \
-v /etc/localtime:/etc/localtime:ro \
-e PGID=998 -e PUID=1000 \
-p 8081:8081 \
technosoft2000/sickrage-cytec
```

__Start the container:__
```
docker start sickrage-cytec
```

## Parameters ##
* -p 8081 - http port for the web user interface
* -v /sickrage/config - local path for sickrage config files
* -v /sickrage/data - local path for sickrage data files (cache, database, ...)
* -v /volume1 - volume hook especially for Snyology NAS users - optional
* -v /etc/localhost for timesync - optional
* -e PGID for GroupID - see below for explanation - optional
* -e PUID for UserID - see below for explanation - optional

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

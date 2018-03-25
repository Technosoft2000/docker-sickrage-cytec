**2018-03-25 - v1.1.4**

 * upgrade to latest base image [technosoft2000/alpine-base:3.6-3](https://hub.docker.com/r/technosoft2000/alpine-base/)

**2017-06-15 - v1.1.3**

 * Log output on console is activated again; I'll create an environment option if I or somebody else gets an issue with it 

 * **___HTTPS___**
   - Self-signed certificate creation via SickRage is working now, 
     btw. Chrome warns that this certificate is of course insecure

**2017-06-03 - v1.1.2**

 * upgrade to new base image technosoft2000/alpine-base:3.6-2
 * supports now PGID < 1000

**2017-05-28 - v1.1.1**

 * upgrade to __Alpine 3.6__ (new base image [technosoft2000/alpine-base:3.6-1](https://hub.docker.com/r/technosoft2000/alpine-base/))
 * the dependency ```cryptography``` requires the usage of ```openssl-dev``` instead of ```libressl-dev```, nevertheless [LibreSSL](https://www.libressl.org/) is still used at runtime

**2017-03-11 - v1.1.0**

 * sickrage-cytec image is based now on ```technosoft2000/alpine-base:3.5-1.0.0```
 * __SR...__ environment variables are changed to __APP...__
 * it's also possible to use sickrage tags as __APP_BRANCH__ input to checkout a specific tagged version
 * updated README.md instructions

**2016-08-28 - v1.0.0**

 * enhanced check regarding timezone
 * enhanced output at startup of the docker container

**2016-08-27**

 * enhanced check regarding UID and GID
 * enhanced output at startup of the docker container
 * TS2k ASCII Logo :D at startup of the docker container

**2016-08-07**

 * automatic restart of SickRage can be done via option --restart=always
 * changed the Docker Image base from Ubuntu 16.04 to Alpine 3.4
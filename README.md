# Dockered TShock

TShock server wrapper for terraria

## Overview

![licence](https://img.shields.io/badge/licence-GNUv3-blue.svg)
![tshock version](https://img.shields.io/badge/tshock-v4.3.5-green.svg)
![terraria api version](https://img.shields.io/badge/TerrariaAPI-2.1-lightgrey.svg)
![terraria version](https://img.shields.io/badge/terraria-1.3.5.3-brightgreen.svg)

May you are a player without any knowledge about installing and running servers
or may you are a tshock server admin who want to create and maintain them in easy way.

So I've created this docker image to help to achieve those objectives.

The only one requirement is to have installed docker ([documentation](https://docs.docker.com/install/)) at your machine/server
and have permissions to run docker command.

## How-to

Just run simple image and free play

```
$ docker run -d \
    -p 7777:7777 -p 7878:7878 \
    --name tshock \
    --network bridge \
    amonetta/tshock:v4.3.25 
```

Just run simple image with server-side-characters enabled

```
$ docker run -d \
    -p 7777:7777 -p 7878:7878 \
    --name tshock \
    --network bridge \
    amonetta/tshock:v4.3.25-ssc 
```

Get auth admin PIN

`$ docker attach tshock`

Copy the pin and then type  `ctrl + p, ctrl + q`

IMPORTANT: Do not leave container by closing windows or `ctrl + c` this will
cause that your server finish.

## Server control

### Stop/Restart

If you want to stop / restart your container

``$ docker stop tshock``

this will allow you to pause your server without data loosing
and will be able to restart at any time using

``$ docker restart tshock`` 

### Backup

``$ docker commit -p tshock``

`p` : is optional param, pause container during image creation.

## Server configuration

### `tsc` commands

`tsc` (tshock command) is a self develop bundle of commands to simplify tshock server configuration and management.

`tsc health`: Show if tshock is running.

`tsc update`: Update tshock server to last version.

    WARNING: This could harm your plugin's installations. It's highly recommended to create a backup and check plugins compatibility before update. 

`tsc config`: Get or Set server config. After run this command, server restart 
is required to reload configuration. 

    tsc config get|set [<config-key>] [<config-value>]

```
$ tsc config get InvasionMultiplier
InvasionMultiplier:1
```

```
$ tsc config get InvasionMultiplier 2
InvasionMultiplier:2
```

You can run this command outside container like this:

`$ docker exec -it tshock tsc update

### Custom configurations

If you want to change tshock server configuration

```
$ docker exec -it tshock nano /opt/tshock/tshock/config.json
: ctrl + p, ctrl +  q
$ docker restart tshock
```

```
$ docker exec -it tshock nano /opt/tshock/tshock/sscconfig.json
: ctrl + p, ctrl +  q
$ docker restart tshock
```


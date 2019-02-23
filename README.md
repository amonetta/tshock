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

If you want to stop / restart your container

``$ docker stop tshock``

this will allow you to pause your server without data loosing
and will be able to restart at any time using

``$ docker restart tshock`` 

If you want to change tshock server configuration

```
$ docker exec -it tshock nano /opt/tshock/tshock/config.jscn
: ctrl + p, ctrl +  q
$ docker restart tshock
```


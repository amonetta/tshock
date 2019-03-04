# Dockered tShock

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

### Simple startup

Just run simple image and free play

```
$ docker run -d \
    -p 7777:7777 -p 7878:7878 \
    --name tshock \
    --network bridge \
    amonetta/tshock:latest
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

### Local volumes

To storage at your host machine your word, you need to start container with `-v` or `--volume` like this:

```
$ docker run -d \
    -p 7777:7777 -p 7878:7878 \
    --name tshock \
    --network bridge \
    --volume $HOME/tschok/Terraria/Words:/opt/tshock/Terraria/Worlds \
    amonetta/tshock:latest
```

For custom volume configuration, you can read docker documentation about volume and mount [here](https://docs.docker.com/storage/volumes)

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

If you want to export your recently created image to other machine, run:

``docker save -o <path for generated tar file> <image name>``

then save the `.tar` file generated and run on target machine:

``docker load -i <path to image tar file>``

Full example

```
$ docker commit -p tshock
sha256:18f834a8e6c997e22d3348f0883d9e718232f52f4175d5f1f62bb35d79c43e74
$ docker save -o ~/tshock/18f834a8e6c9.tar 18f834a8e6c9
```

Save `18f834a8e6c9.tar` to other machine and run: 

```
$ docker load -i ~/tshock/18f834a8e6c9.tar
$ docker run -d \
      -p 7777:7777 -p 7878:7878 \
      --name tshock \
      --network bridge \
      18f834a8e6c9
```

## Server configuration

### `tsc` commands

`tsc` (tshock command) is a self develop bundle of commands to simplify tshock server configuration and management.

`tsc config`: Get/Set tShock server main config.

`tsc ssc`: Get/Set tShock server SSC config.

`tsc health`: Show if tshock is running.

`tsc update`: Update tshock server to last version.

`tsc version`: Gets tShock actual version.

    WARNING: This could harm your plugin's installations. It's highly recommended to create a backup and check plugins compatibility before update. 

`tsc config`: Get or Set server config. After run this command, server restart 
is required to reload configuration. 

    tsc config get|set [<config-key>] [<config-value>]

```
$ tsc config get InvasionMultiplier
InvasionMultiplier:1
```

```
$ tsc config set InvasionMultiplier 2
InvasionMultiplier:2
```

Use also `-h` or `--help` option to get further information about running commands.

You can run this command outside container like this:

`$ docker exec -it tshock tsc update`

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


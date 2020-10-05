# minecraft-server
Run a minecraft spigot server in a Docker container.

Now with automated server updates. Just restart the container.

[![Docker Automated build](https://img.shields.io/docker/automated/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server)
[![Docker Stars](https://img.shields.io/docker/stars/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server)
[![Docker Pulls](https://img.shields.io/docker/pulls/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server)
[![Docker Build Status](https://img.shields.io/docker/build/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server/builds)


This Dockerfile will download the Minecraft Server app and set it up, along with its dependencies.

If you run the container as is, the `worlds` directory will be created inside the container, which is inadvisable.
It is highly recommended that you store your worlds outside the container using a mount (see the example below).
Ensure that your file system permissions are correct, `chown 1000:1000 mount/path`, and/or modify the UID/GUID variables as needed.

It is also likely that you will want to customize your `server.properties` file.
To do this, use the `-e <ENVIRONMENT_VARIABLE>=<value>` for each setting in the `server.properties`.
The `server.properties` file will be overwritten every time the container is launched. See below for details.


## Example

Use this `docker run` command to launch a container with a few customized `server.properties`.

 $ `docker run -d -it --name=mc -v /opt/mcpe/world1:/home/minecraft/server -p 19132-19133:19132-19133/udp -p 19132-19133:19132-19133/tcp -e ONLINE-MODE=false -e ALLOW-CHEATS=true -e SERVER-NAME=mcpe.example.org nsnow/minecraft-server:latest`


## Additional Docker commands

**kill and remove all docker containers**

`docker kill $(docker ps -qa); docker rm $(docker ps -qa)`

**docker logs**

`docker logs mc`

**attach to the minecraft server console**

you don't need any rcon nonsense with docker attach!

`docker attach mc`

**exec into the container's bash console**

`docker exec mc bash`


**NOTE**: referencing containers by name is only possible if you specify the `--name` flag in your docker run command.


## Set selinux context for mounted volumes

`chcon -Rt svirt_sandbox_file_t /path/to/volume`


## List of server properties and environment variables

**Override the minecraft server version**

By default restarting the container will pull down the latest version.

However, if you need to version pin your container, use the following environment variable override.

* SPIGOT_VERSION=1.16.3

**Set user and/or group id (optional)**
* UID=1000
* GUID=1000

### Template server.properties
This project uses [Remco config management](https://github.com/HeavyHorst/remco).
This allows for templatization of config files and options can be set using environment variables.
This allows for easier deployments using most docker orchistration/management platforms including Kubernetes.

The remco tempate uses keys. This means you should see a string like `"/minecraft/some-option"` within the getv() function.
This directly maps to a environment variable, the `/` becomes an underscore basically. The other value in the getv() function is the default value.
For instance, `"/minecraft/some-option"` will map to the environment variable `MINECRAFT_SOME-OPTION`.

getv("/minecraft/some-option", "default-value")

becomes

`docker -e MINECRAFT_SOME-OPTION=my-value ...`

Use the following file for full environment variable reference.

https://github.com/japtain-cack/minecraft-server/blob/master/remco/templates/server.properties
 

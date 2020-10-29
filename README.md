# minecraft-server
Run a minecraft spigot server in a Docker container.

Now with automated server updates and smart spigot compiling logic (see setting spigot version below).

[![Docker Automated build](https://img.shields.io/docker/automated/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server)
[![Docker Stars](https://img.shields.io/docker/stars/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server)
[![Docker Pulls](https://img.shields.io/docker/pulls/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server)
[![Docker Build Status](https://img.shields.io/docker/build/nsnow/minecraft-server.svg)](https://hub.docker.com/r/nsnow/minecraft-server/builds)


This Dockerfile will download the Minecraft Server app and set it up, along with its dependencies.

If you run the container as is, the `worlds` directory will be created inside the container, which is inadvisable.
It is highly recommended that you store your worlds outside the container using a mount (see the example below).
Ensure that your file system permissions are correct, `chown 1000:1000 mount/path`, and/or modify the UID/GUID variables as needed (see below).

It is also likely that you will want to customize your `server.properties` file.
To do this, use the `-e <ENVIRONMENT_VARIABLE>=<value>` for each setting in the `server.properties`.
The `server.properties` file will be overwritten every time the container is launched. See below for details.


## Run the server

Use this `docker run` command to launch a container with a few customized `server.properties`.

```
docker run -d -it --name=minecraft -v /opt/minecraft/world1:/home/minecraft/server -p 25565:25565/udp -p 25565:25565/tcp \
  -e "MINECRAFT_ONLINE-MODE": "true" \
  -e "MINECRAFT_ALLOW-FLIGHT": "true" \
  -e "MINECRAFT_DIFFICULTY": "normal" \
  -e "MINECRAFT_LEVEL-NAME": "minecraft" \
  -e "MINECRAFT_LEVEL-TYPE": "amplified" \
  -e "MINECRAFT_MAX-BUILD-HEIGHT": "1024" \
  -e "MINECRAFT_MOTD": "Welcome to my minecraft server" \
  -e "MINECRAFT_PLAYER-IDLE-TIMEOUT": "60" \
  -e "MINECRAFT_PVP": "false" \
  -e "MINECRAFT_EULA": "TRUE" \
  -e "SPIGOT_VERSION": "1.16.3" \
  -e "JAVA_MEMORY": "1024" \
  nsnow/minecraft-server:latest
```


## Additional Docker commands

**kill and remove all docker containers**

`docker kill $(docker ps -qa); docker rm $(docker ps -qa)`

**docker logs**

`docker logs minecraft`

**attach to the minecraft server console**

You don't need any rcon nonsense with docker attach!

Use `ctrl+p` then `ctrl+q` to quit.

`docker attach minecraft`

**exec into the container's bash console**

`docker exec minecraft bash`


**NOTE**: referencing containers by name is only possible if you specify the `--name` flag in your docker run command.


## Set selinux context for mounted volumes

`chcon -Rt svirt_sandbox_file_t /path/to/volume`


## Server properties and environment variables

**Override the minecraft server version**

By default restarting the container will pull down the latest version.
However, **you should version pin your spigot version**, use the following environment variable override.

If you don't set a version, it can't know which version you want and will compile spigot from scratch each time.
**This will drastically increase your container start times**.

To update, simply set the new version number and restart your container!

* `SPIGOT_VERSION=latest`

or

* `SPIGOT_VERSION=1.16.3`

**NOTE:** See [BuildTools Install Docs](https://www.spigotmc.org/wiki/buildtools/#versions) for versioning info.

**Set user and/or group id (optional)**
* `MINECRAFT_UID=1000`
* `MINECRAFT_GUID=1000`

### server.properties
Use [this file](https://github.com/japtain-cack/minecraft-server/blob/master/remco/templates/server.properties) for the full environment variable reference.
 
This project uses [Remco config management](https://github.com/HeavyHorst/remco).
This allows for templatization of config files and options can be set using environment variables.
This allows for easier deployments using most docker orchistration/management platforms including Kubernetes.

The remco tempate uses keys. This means you should see a string like `"/minecraft/some-option"` within the `getv()` function.
This directly maps to a environment variable, the `/` becomes an underscore basically. The other value in the `getv()` function is the default value.
For instance, `"/minecraft/some-option"` will map to the environment variable `MINECRAFT_SOME-OPTION`.

`getv("/minecraft/some-option", "default-value")`

becomes

`docker run -e MINECRAFT_SOME-OPTION=my-value ...`


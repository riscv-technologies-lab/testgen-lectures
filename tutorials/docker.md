# Docker

![Docker logo](img/Docker_logo.svg "Docker logo")

If you didn't setup docker please firstly use [this guide](docker-setup.md).

## Docker objects
When you use Docker, you are creating and using images, containers, networks,
volumes, plugins, and other objects. This section is a brief overview of some of
those objects.

### Images
An image is a read-only template with instructions for creating a Docker
container. Often, an image is based on another image, with some additional
customization. For example, you may build an image which is based on the ubuntu
image, but installs the Apache web server and your application, as well as the
configuration details needed to make your application run.

You might create your own images or you might only use those created by others
and published in a registry. To build your own image, you create a Dockerfile
with a simple syntax for defining the steps needed to create the image and run
it. Each instruction in a Dockerfile creates a layer in the image. When you
change the Dockerfile and rebuild the image, only those layers which have changed
are rebuilt. This is part of what makes images so lightweight, small, and fast,
when compared to other virtualization technologies.

In following examples it's supposed that environment variable `IMAGE` stores
image name.

### Containers
A container is a runnable instance of an image. You can create, start, stop,
move, or delete a container using the Docker API or CLI. You can connect a
container to one or more networks, attach storage to it, or even create a new
image based on its current state.

By default, a container is relatively well isolated from other containers and its
host machine. You can control how isolated a container's network, storage, or
other underlying subsystems are from other containers or from the host machine.

A container is defined by its image as well as any configuration options you
provide to it when you create or start it. When a container is removed, any
changes to its state that aren't stored in persistent storage disappear.

In following examples it's supposed that environment variable `CONTAINER` stores
container name.

## Most regular docker commands

### Pull an image

The `docker image pull` (or shorthand: `docker pull`) command download an image
from a registry.

Example:
``` sh
docker pull ${IMAGE}
```

### Show images

The following commands are equivalent and list images:
```sh
docker image ls
docker image list
docker images
```

### Remove an image

The `docker image remove` (or shorthands: `docker image rm` or `docker rmi`)
command removes one or more images.

This does not remove images from a registry. You cannot remove an image of a
running container unless you use the `-f` option. To see all images on a host use
the docker image ls command.

Examples:
```sh
docker rmi ${IMAGE} # just remove image
```
```sh
docker rmi -f ${IMAGE} # remove image and all containers associated with it
```

You can also use `docker image prune` command. It remove all dangling images. If
`-a` is specified, also remove all images not referenced by any container.

Example:
```sh
docker image prune -a
```

### Create a container

The `docker container create` (or shorthand: `docker create`) command creates a
new container from the specified image, without starting it.

When creating a container, the Docker daemon creates a writeable container layer
over the specified image and prepares it for running the specified command. The
container ID is then printed to `STDOUT`. This is similar to `docker run -d`
except the container is never started. You can then use the `docker container
start` (or shorthand: `docker start`) command to start the container at any point.

This is useful when you want to set up a container configuration ahead of time so
that it's ready to start when you need it. The initial status of the new
container is created.

The `docker create` command shares most of its options with the
[`docker run`](#create-and-start-container-in-one-command) command
(which performs a `docker create` before starting it). Refer to the docker run
CLI reference for details on the available flags and options.

Example:
```sh
docker create \
    --interactive \ # keep STDIN open even if not attached
    --tty \ # allocate a pseudo-TTY
	--env "TERM=xterm-256color" \ # enable colors
	--mount type=bind,source="$$(pwd)",target="$$(pwd)" \ # mount source dir to target dir
	--name ${CONTAINER} \ # set container name
	--ulimit nofile=1024:1024 \ # workaround for valgring
	--user "$$(id -u ${USER}):$$(id -g ${USER})" \ # preserve user accesses and ownership
	--workdir "$$HOME" \ # working directory inside the container
	${IMAGE} # image name for this container
```

### Start a container
The `docker container start` (or shorthand: `docker start`) command starts one or
more stopped containers.

Example:
```sh
docker start ${CONTAINER}
```

### Execute command in a running container

The `docker container exec` (or shorthand: `docker exec`) command runs a new
command in a running container.

The command you specify with docker exec only runs while the container's primary
process (PID 1) is running, and it isn't restarted if the container is restarted.

The command runs in the default working directory of the container.

The command must be an executable. A chained or a quoted command doesn't work.
- This works: `docker exec -it ${CONTAINER} sh -c "echo a && echo b"`
- This doesn't work: `docker exec -it ${CONTAINER} "echo a && echo b"`

Example:
```sh
docker exec -it ${CONTAINER} sh # attach interactive shell inside container
```
```sh
docker exec --detach ${CONTAINER} make # run command in the background
```

### Create and start container in one command

The `docker container run` (or shorthand: `docker run`) command runs a command in
a new container, pulling the image if needed and starting the container.

You can restart a stopped container with all its previous changes intact using
`docker start`. Use `docker ps -a` to view a list of all containers, including
those that are stopped.

Since this command is 

Example:
```sh
docker run \
    --interactive \ # keep STDIN open even if not attached
    --tty \ # allocate a pseudo-TTY
    --detach \ # run command in the background
	--env "TERM=xterm-256color" \ # enable colors
	--mount type=bind,source="$$(pwd)",target="$$(pwd)" \ # mount source dir to target dir
	--name ${CONTAINER} \ # set container name
	--ulimit nofile=1024:1024 \ # workaround for valgring
	--user "$$(id -u ${USER}):$$(id -g ${USER})" \ # preserve user accesses and ownership
	--workdir "$$HOME" \ # working directory inside the container
	${IMAGE} # image name for this container
```

### Stop running container

The `docker container stop` (or shorthand: `docker stop`) command stops one or
more stopped containers.

The main process inside the container will receive `SIGTERM`, and after a grace
period, `SIGKILL`. The first signal can be changed with the `STOPSIGNAL`
instruction in the container's Dockerfile, or the `--stop-signal` option to
docker run.

Example:

```sh
docker stop ${CONTAINER}
```

### Show running containers

The following commands are equivalent and list running containers:
```sh
docker container ls
docker container list
docker container ps
docker ps
```

### Show all containers (including stopped one)

The following commands are equivalent and list all containers:
```sh
docker container ls -a
docker container list -a
docker container ps -a
docker ps -a
```

### Remove a container

The `docker container remove` (or shorthands: `docker container rm` or
`docker rm`) command removes one or more containers.

Example:
```sh
docker rm ${CONTAINER}
```

By default only stopped containers can be removed. Use `--force` to force-remove
running container:
```sh
docker rm --force ${CONTAINER}
```

### Remove all stopped containers

```sh
docker container prune
```

## Recommended docker workflow

```sh
docker run \
    --interactive \ # keep STDIN open even if not attached
    --tty \ # allocate a pseudo-TTY
    --detach \ # run command in the background
	--env "TERM=xterm-256color" \ # enable colors
	--mount type=bind,source="$$(pwd)",target="$$(pwd)" \ # mount source dir to target dir
	--name ${CONTAINER} \ # set container name
	--ulimit nofile=1024:1024 \ # workaround for valgring
	--user "$$(id -u ${USER}):$$(id -g ${USER})" \ # preserve user accesses and ownership
	--workdir "$$HOME" \ # working directory inside the container
	${IMAGE} # image name for this container
# Create group associated with your user
docker exec --user root ${CONTAINER} bash -c "groupadd ${USER} -g $(id -g ${USER})"
# Create user with same uid and gid as host user
docker exec --user root ${CONTAINER} bash -c "useradd ${USER} -u $(id -u ${USER}) -g $(id -g ${USER})"
# Launch application in backgroud
docker exec -d ${CONTAINER} sh -c "very-usefull-daemon -f" 
# Work in container interactively
docker exec -it ${CONTAINER} bash
```

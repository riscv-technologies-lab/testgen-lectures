# Docker Setup

![Docker logo](img/Docker_logo.svg "Docker logo")

**Docker** is a tool that allows developers, sys-admins etc. to easily deploy their
applications in a sandbox (called containers) to run on the host operating system
i.e. Linux. The key benefit of Docker is that it allows users to package an
application with all of its dependencies into a standardized unit for software
development. Unlike virtual machines, containers do not have high overhead and
hence enable more efficient usage of the underlying system and resources.

## Installation steps

### Ubuntu (or ubuntu based distros)

To install Docker Engine, you need the 64-bit version of one of these Ubuntu versions:
- Ubuntu Mantic 23.10
- Ubuntu Jammy 22.04 (LTS)
- Ubuntu Focal 20.04 (LTS)

Firstly, add repository:
```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Secondly, install packages:
```sh
sudo apt-get install docker-ce \
                     docker-ce-cli \
                     containerd.io \
                     docker-buildx-plugin \
                     docker-compose-plugin
```

Finally, ensure that docker installation succeeded:
```sh
sudo docker run hello-world
```
This command downloads a test image and runs it in a container. When the
container runs, it prints a confirmation message and exits.

### Other distros

If you use other disto you can check official installation [instruction](https://docs.docker.com/engine/install/ "Docker installation instruction").

## Post-installation steps

The Docker daemon binds to a Unix socket, not a TCP port. By default it's the
`root` user that owns the Unix socket, and other users can only access it using
`sudo`. The Docker daemon always runs as the `root` user.

If you don't want to preface the `docker` command with `sudo`, create a Unix
group called `docker` and add users to it. When the Docker daemon starts, it
creates a Unix socket accessible by members of the `docker` group. On some Linux
distributions, the system automatically creates this group when installing Docker
Engine using a package manager. In that case, there is no need for you to
manually create the group.

To create the `docker` group and add your user:
1. Create the `docker` group.
   ```sh
   sudo groupadd docker
   ```
1. Add your user to the `docker` group.
   ```sh
   sudo usermod -aG docker $USER
   ```
1. Log out and log back in so that your group membership is re-evaluated.
1. Verify that you can run docker commands without sudo.
   ```sh
   docker run hello-world
   ```
   This command downloads a test image and runs it in a container. When the
   container runs, it prints a message and exits.

If you initially ran Docker CLI commands using sudo before adding your user to
the docker group, you may see the following error:
```
WARNING: Error loading config file: /home/user/.docker/config.json -
stat /home/user/.docker/config.json: permission denied
```
This error indicates that the permission settings for the `~/.docker/` directory
are incorrect, due to having used the `sudo` command earlier.

To fix this problem, either remove the `~/.docker/` directory (it's recreated
automatically, but any custom settings are lost), or change its ownership and
permissions using the following commands:
```sh
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```


## Configure Docker to start on boot with systemd

Many modern Linux distributions use `systemd` to manage which services start when
the system boots. On Debian and Ubuntu, the Docker service starts on boot by
default. To automatically start Docker and containerd on boot for other Linux
distributions using systemd, run the following commands:
```sh
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```
To stop this behavior, use disable instead.
```sh
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

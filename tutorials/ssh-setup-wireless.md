# How to setup a board network connection for wireless connection

Firstly, you need to get IP address and port from the teacher.
Save them:

```sh
LICHEE_IPV4='...'
LICHEE_SSH_PORT='...'
```

## SSH connection

For now you have everything to install ssh connection with your board with following commands

```sh
ssh -p ${LICHEE_SSH_PORT} "sipeed@${LICHEE_IPV4}"
```

**note**:

* *User:* **sipeed**
* *Password:* **licheepi**

### Connection without password

Enter password every time is annoying.
You can copy your ssh key to the board to connect without entering password:

```sh
ssh-copy-id -p ${LICHEE_SSH_PORT} "sipeed@${LICHEE_IPV4}"
```

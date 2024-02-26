#### How to setup a board network connection

**note:** you should do this after board physical connection via cable 

First of all, you need to setup your wired network connection.
* Open network settings 
* Choose settings for your active wired connection
* Open **IPv4** tab 
* Select **Shared to other computers** method

Now you need to get a current IP address for ethernet device 

```sh
ip address show
```

For example, you can see something like that: 
```
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether c8:5a:cf:b5:3e:51 brd ff:ff:ff:ff:ff:ff
    inet 10.42.0.1/24 brd 10.42.0.255 scope global noprefixroute enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::59a5:a913:8b3d:2265/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

```

You need to pick this `10.42.0.1/24` address 
```sh
export ETHERNET_IPV4='10.42.0.1/24'
```

**note**: *Ethernet* device is something beginning with 'e' 

After that to find board IP scan the network with the following command (be sure you have `nmap` utility installed in your PC)

```sh
nmap -sn ${ETHERNET_IPV4}
```

It's expected it gives you an IP address. Save it
```sh
LICHEE_IPV4='...'
``` 

### SSH connection
For now you have everything to install ssh connection with your board with following commands
```sh
ssh sipeed@10.42.0.208
```

**note**:
* *User:* **sipeed**
* *Password:* **licheepi** 
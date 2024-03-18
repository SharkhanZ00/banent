# BanEnt

Banent is a scripts set to temporary activate and deactivate OpenWrt firewall rules remotly using any GNU/Linux host with SSH.

## Overview

 * The first script (banent) can activate and deactivate (ubanent) firewall rules
 * The second script can remotly execute first script using SSH
 * It also contains script to invasion fitst script to OpenWrt routers

## Build and installation

### Requirements for managing host
> GNU/Linux with bash, sed and base64
> ssh client to generate public key


### Requirements for managed host
> GNU/Linux with ash, useradd and base64

You can install it with opkg or luci from usual OpenWrt repository.
 
Checkout project any method. In started configuration directory can contain links for banent and banent scripts.
Make these links:
```sh
make
make install
```
To do invasion it`s nessesary build sending artifact
```sh
make banent.tgz
```
Use ssh-keygen to create SSH key pair with type RSA.
To send it to one or more Openwrt hosts invoke incasion-owrt.sh:
```
./invasion-owrt.sh root@router root@gate
Password:
Invasion successful
Password:
Invasion successful
```
It will create on managed host special user "hass-rpc" and copy public key to home secret dir. After that you can ban and unban rules:
```
banent router 0 1
```
```
unbanent router 0 1
```

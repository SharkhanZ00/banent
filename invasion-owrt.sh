#!/bin/bash

REMOTES="root@router"

test -f $HOME/.ssh/id_rsa.pub || exit 1
TAR=$(base64 -w0 banent.tar)
SSH_PK=$(cat $HOME/.ssh/id_rsa.pub | base64 -w0)

SCRIPT=" \
/bin/ash -c 'useradd -N -r -m hass-rpc && \
echo $TAR | base64 -d | tar -vx -C /' && \
mkdir -p /overlay/upper/home/hass-rpc/.ssh && cat '$SSH_PK' | base64 -d >> /overlay/upper/home/hass-rpc/.ssh/.authorized_keys && \
chown -R /overlay/upper/home/hass-rpc/.ssh/.authorized_keys && chmod 0600 /overlay/upper/home/hass-rpc/.ssh/.authorized_keys && chmod 0700 /overlay/upper/home/hass-rpc/.ssh"

for REMOTE in $REMOTES; do

  echo ssh $REMOTE "$SCRIPT"

done

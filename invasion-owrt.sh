#!/bin/bash

REMOTES=$*

test -f $HOME/.ssh/id_rsa.pub || exit 1
test -f ./banent.tgz || exit 2
TAR=$(base64 -w0 ./banent.tgz)
SSH_PK=$(cat $HOME/.ssh/id_rsa.pub | base64 -w0)

SCRIPT="\
/bin/ash -c 'cat /etc/passwd | grep hass-rpc > /dev/null || useradd -N -r -m hass-rpc -s /bin/ash && \
echo $TAR | base64 -d | tar -vzx -C / && \
mkdir -p /overlay/upper/home/hass-rpc/.ssh && echo '$SSH_PK' | base64 -d >> /overlay/upper/home/hass-rpc/.ssh/authorized_keys && \
chown -R hass-rpc:users /overlay/upper/home/hass-rpc/.ssh/authorized_keys && chmod 0600 /overlay/upper/home/hass-rpc/.ssh/authorized_keys && chmod 0700 /overlay/upper/home/hass-rpc/.ssh'"

for REMOTE in $REMOTES; do

  ssh '-oHostKeyAlgorithms=+ssh-rsa' '-oPubkeyAcceptedKeyTypes=+ssh-rsa' $REMOTE "$SCRIPT"

done

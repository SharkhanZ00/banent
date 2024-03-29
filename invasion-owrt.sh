#!/bin/bash

# set -x

REMOTES=$*

test -f $HOME/.ssh/id_rsa.pub || exit 1
test -f ./banent.tgz || exit 2
TAR=$(base64 -w0 ./banent.tgz)
SSH_PK=$(cat $HOME/.ssh/id_rsa.pub | base64 -w0)

SCRIPT="\
/bin/ash -c 'cat /etc/passwd | grep -qF -e hass-rpc || useradd -N -r -m hass-rpc -s /bin/ash && \
echo $TAR | base64 -d | tar -zx -C / && \
mkdir -p /home/hass-rpc/.ssh && ( grep -qF -e \"\$(echo -n $SSH_PK | base64 -d)\" /home/hass-rpc/.ssh/authorized_keys 2>/dev/null || echo '$SSH_PK' | base64 -d >> /home/hass-rpc/.ssh/authorized_keys ) && \
chown -R hass-rpc:users /home/hass-rpc && chmod 0600 /home/hass-rpc/.ssh/authorized_keys && chmod 0700 /home/hass-rpc/.ssh && \
( test -d /overlay/upper && echo $TAR | base64 -d | tar -zx -C /overlay/upper && mkdir -p /overlay/upper/home && cp -r /home/hass-rpc /overlay/upper/home ) || true && \
echo Invasion successful'"

for REMOTE in $REMOTES; do

  ssh '-oHostKeyAlgorithms=+ssh-rsa' '-oPubkeyAcceptedKeyTypes=+ssh-rsa' $REMOTE "$SCRIPT"

done

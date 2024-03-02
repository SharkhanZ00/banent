#!/bin/bash

REMOTE=$1
echo "$REMOTE" | grep -E '^[0-9]+$' > /dev/null
IS_DIGIT=$?
if [ "z${REMOTE}z" = "zz" -o "$IS_DIGIT" = '0' ]; then
  exit 1
else
  #TODO check $REMOTE begins with sss
  REMOTE="$REMOTE  -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa" #TODO remove then OpenWrt (powered Dropbear SSH) starts support modern cyphers
  shift
fi

CONFS=$*
if [ "z${CONFS}z" = "zz" ]; then
  CONFS='0'
fi

ROLE="sudo $(basename $0)"
for CONF in $CONFS; do
  REMOTE_CMD="$REMOTE_CMD $CONF "
done
$REMOTE $REMOTE_CMD

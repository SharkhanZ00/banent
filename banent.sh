#!/bin/bash

REMOTE=$1
if [ "z${REMOTE}z" = "zz" ]; then
  REMOTE='echo '
else
  shift
fi

CONFS=$*
if [ "z${CONFS}z" = "zz" ]; then
  CONFS='0'
fi
REMOTE_CMD=''
for CONF in $CONFS; do
  BAN="uci set firewall.@rule[$CONF].enabled=1"
  ROLE=$(basename $0)
  if [ "$ROLE" = "unbanent" ]; then
    BAN="uci revert firewall.@rule[$CONF]"
  fi
  REMOTE_CMD="$REMOTE_CMD $BAN &&"
done
REMOTE_CMD="$REMOTE_CMD fw3 reload"
$REMOTE $REMOTE_CMD

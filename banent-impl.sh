#!/bin/bash

BAN_TEMP='uci set firewall.@rule[$CONF].enabled=1'
UNBAN_TEMP='uci revert firewall.@rule[$CONF]'

CONFS=$*
if [ "z${CONFS}z" = "zz" ]; then
  CONFS='0'
fi

REMOTE_CMD=''
for CONF in $CONFS; do
  BAN=eval echo $BAN_TEMP
  ROLE=$(basename $0)
  if [ "$ROLE" = "unbanent" ]; then
    BAN=eval echo $UNBAN_TEMP
  fi
  REMOTE_CMD="$REMOTE_CMD $BAN &&"
done
REMOTE_CMD="$REMOTE_CMD fw3 reload"
$REMOTE $REMOTE_CMD

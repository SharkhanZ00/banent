#!/bin/bash

BAN_TEMP='uci set firewall.@rule[$CONF].enabled=1'
UNBAN_TEMP='uci revert firewall.@rule[$CONF]'

REMOTE=$1
echo "$REMOTE" | grep -E '^[0-9]+$' > /dev/null
IS_DIGIT=$?
if [ "z${REMOTE}z" = "zz" -o "$IS_DIGIT" = '0' ]; then
  REMOTE='echo '
  BAN_TEMP='sudo banent $CONF'
  UNBAN_TEMP='sudo unbanent $CONF'
else
  shift
fi

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

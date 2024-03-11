#!/bin/ash

BAN_TEMP='uci set firewall.@rule[$CONF].enabled=1'
UNBAN_TEMP='uci revert firewall.@rule[$CONF]'

CONFS=$*
if [ "z${CONFS}z" = "zz" ]; then
  CONFS='0'
fi

LOCAL_CMD=''
for CONF in $CONFS; do
  BAN=$(eval $BAN_TEMP)
  ROLE=$(basename $0)
  if [ "$ROLE" = "unbanent" ]; then
    BAN=$(eval $UNBAN_TEMP)
  fi
  LOCAL_CMD="$LOCAL_CMD $BAN &&"
done
LOCAL_CMD="$LOCAL_CMD fw3 reload"
$LOCAL_CMD

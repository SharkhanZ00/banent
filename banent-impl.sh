#!/bin/ash

BAN_TEMP='uci set firewall.@rule[$CONF].enabled=1'
UNBAN_TEMP='uci revert firewall.@rule[$CONF]'

CONFS=$*
if [ "z${CONFS}z" = "zz" ]; then
  CONFS='0'
fi

LOCAL_CMD=''
ROLE=$(basename $0)
for CONF in $CONFS; do
  BAN=$(eval echo -n $BAN_TEMP)
  if [ "$ROLE" = "unbanent" ]; then
    BAN=$(eval echo -n $UNBAN_TEMP)
  fi
  LOCAL_CMD="$LOCAL_CMD $BAN &&"
done
LOCAL_CMD="$LOCAL_CMD fw3 reload"
/bin/ash -c "$LOCAL_CMD"

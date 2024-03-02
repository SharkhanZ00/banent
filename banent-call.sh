#!/bin/bash

REMOTE=$1
echo "$REMOTE" | grep -E '^[0-9]+$' > /dev/null
IS_DIGIT=$?
if [ "z${REMOTE}z" = "zz" -o "$IS_DIGIT" = '0' ]; then
  exit 1
else
  shift
fi

CONFS=$*
if [ "z${CONFS}z" = "zz" ]; then
  CONFS='0'
fi

REMOTE_CMD=eval echo $BAN_TEMP
ROLE=$(basename $0)
if [ "$ROLE" = "unbanent" ]; then
  REMOTE_CMD=eval echo $UNBAN_TEMP
fi
for CONF in $CONFS; do
  REMOTE_CMD="$REMOTE_CMD $CONF &&"
done
REMOTE_CMD="$REMOTE_CMD fw3 reload"
$REMOTE $REMOTE_CMD

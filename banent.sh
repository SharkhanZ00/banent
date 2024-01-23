#! /bin/ash

BAN='1'
COMMIT=''
ROLE=$(basename $0)
if [ "$ROLE" = "unbanent" ]; then
  BAN='0'
  COMMIT=' && uci commit'
fi
firewall.@rule[0].enabled="$BAN" $COMMIT && fw3 reload

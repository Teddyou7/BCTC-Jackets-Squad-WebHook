#!/bin/bash
# PlayersJoinTheBroadcast.sh
# 玩家加入房间自动化天气播报脚本
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

USER_IP=$1
usersteamid=$2

# 判断身份
IfVip=$(cat ${WBHKHOME}/date/BasicData/PlayersJoinTheBroadcast | grep $usersteamid | wc -l)
if [ $IfVip -eq 0 ] ; then
	echo "$usersteamid no vip"
	exit
fi

mssg=$(cat ${WBHKHOME}/date/BasicData/PlayersJoinTheBroadcast | grep $usersteamid | awk -F '%%' '{print $2}')

sleep 20

$CMDSH AdminBroadcast $mssg
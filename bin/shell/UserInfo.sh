#!/bin/bash
#UserInfo.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/UserInfo
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.name}}%%{{player.steamID}}%%1"
# }
#}
#用户信息查询 20231217 Teddyou

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#ServerID
ServerID=`echo $1|awk -F '%%' '{print $3}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $steamID)

RESREVEIF=`cat $ReservedUserInfo | grep $steamID | wc -l`
if [ "$RESREVEIF" -eq 1 ];then
	AccountBalance=`cat $ReservedUserInfo |grep $steamID |awk -F \: '{print $2}'`
	$CMDSH AdminWarnById $PlayerID 预留位到期时间：`date -d @${AccountBalance} +"%Y/%m/%d %H:%M"`
	sleep 1
fi

POINTSIF=`cat $PointsUserInfo | grep $steamID | wc -l`
if [ "$RESREVEIF" -eq 1 ];then
	AccountBalance=`cat $PointsUserInfo |grep $steamID |awk -F \: '{print $2}'`
	$CMDSH AdminWarnById $PlayerID 积分余额：${AccountBalance}
	sleep 1
fi

SIGNVIPIF=`cat $SignVIPUserInfo | grep $steamID | wc -l`
if [ "$RESREVEIF" -eq 1 ];then
	AccountBalance=`cat $SignVIPUserInfo |grep $steamID |awk -F \: '{print $2}'`
	$CMDSH AdminWarnById $PlayerID 签到特权到期时间：`date -d @${AccountBalance} +"%Y/%m/%d %H:%M"`
	sleep 1
fi


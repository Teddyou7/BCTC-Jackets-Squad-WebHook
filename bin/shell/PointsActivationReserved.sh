#!/bin/bash
#PointsActivationReserved.sh
#积分激活预留位功能
#传入："${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
msg_body=$(echo $1|awk -F '%%' '{print $3}')
ServerID=$(echo $1|awk -F '%%' '{print $4}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

UsingPoints=$(echo $msg_body | awk '{print $2}')
PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)

if [ -z "$UsingPoints" ]; then
	$CMDSH AdminWarnById $PlayerID 请使用兑换命令为[注意空格]：兑换 [积分数额]
	exit
fi

#判断是否低于最低值
CurrentBalance=$(cat $PointsUserInfo | grep $player_steamID | awk -F \: '{print $2}' | tail -1)
if [ $UsingPoints -lt $PointsActivationReservedLow ];then
	$CMDSH AdminWarnById $PlayerID 兑换失败，最少使用${PointsActivationReservedLow}${PointsName}。
	exit
fi

#判断当前积分是否足够
if [ $CurrentBalance -ge $UsingPoints ];then
	#执行兑换程序
	${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$player_steamID" "$((UsingPoints * PointsToReserved))" "2"
	${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$player_steamID" "$UsingPoints" "4"
	echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:通过${UsingPoints}积分兑换预留位$((UsingPoints * PointsToReserved))" >> $UserOperateLog/$player_steamID
	ReservedTime=`cat $ReservedUserInfo |grep $player_steamID |awk -F \: '{print $2}'`
	$CMDSH AdminWarnById $PlayerID 预留位兑换成功，到期时间：`date -d @${ReservedTime} +"%Y/%m/%d %H:%M"`
else
	$CMDSH AdminWarnById $PlayerID 兑换失败，${PointsName}余额不足，当前剩余$CurrentBalance
fi

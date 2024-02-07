#!/bin/bash
# ChangeCamp.sh
# 积分跳边

#设置语言环境
export LANG=en_US.UTF-8

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
ServerID=$(echo $1|awk -F '%%' '{print $3}')

if [ $ChangeCampSwitch -eq 0 ] ; then
	$CMDSH AdminWarn $player_steamID 本服务器管理员已禁用积分跳边功能
	exit
fi

ChangeCampCDCheck=$($mysql_cmd "SELECT * FROM transactions WHERE transaction_time >= NOW() - INTERVAL ${ChangeCampCD} MINUTE AND steamid = '$player_steamID' AND organization_tag = '$db_tag' AND note = 'ChangeCampPoints';")

if [ -z "$ChangeCampCDCheck" ]; then
	${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceTeamChange $player_steamID " ok
else
	$CMDSH AdminWarn $player_steamID 您在${ChangeCampCD}分钟内曾使用过此功能，不允许再次使用。
	exit
fi

isNotZero=$(echo "$ChangeCampPoints != 0" | bc)
# 检查是否设置收费
if [ $isNotZero -eq 1 ]; then
	#判断当前积分是否足够
	CurrentBalance=$($mysql_cmd "SELECT current_balance FROM transactions WHERE steamid='$player_steamID' AND organization_tag='$db_tag' ORDER BY transaction_time DESC LIMIT 1;")
	if [ $(echo "$CurrentBalance >= $ChangeCampPoints" | bc) -eq 1 ]; then
		Balance=$(${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$player_steamID" "del" "${ChangeCampPoints}" "ChangeCampPoints")
		$CMDSH AdminWarn $player_steamID 跳边成功，已扣除${ChangeCampPoints}${PointsName}，当前剩余$Balance
	else
		$CMDSH AdminWarn $player_steamID 功能使用失败，需要${ChangeCampPoints}${PointsName}，当前剩余$CurrentBalance
		exit
	fi
fi

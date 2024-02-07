#!/bin/bash
#HistoricalMap.sh
#设置语言环境
export LANG=en_US.UTF-8
#传入："${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
ServerID=$(echo $1|awk -F '%%' '{print $3}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

if [ "$HistoricalMapSwitch" -eq "0" ]; then
	$CMDSH AdminWarnById $player_steamID 服务器管理员已关闭历史地图查询功能。
	exit
fi

if [ ${HistoricalMapNumber} -eq 0 ]; then
	$CMDSH AdminWarnById $player_steamID HistoricalMapNumber错误。
	exit
fi

HistoricalMapName=($($mysql_cmd "SELECT map_name FROM ${db_server}historical_layers ORDER BY timestamp DESC LIMIT $HistoricalMapNumber;"))
#HistoricalMapTime=($($mysql_cmd "SELECT REPLACE(timestamp, ' ', '_') FROM ${db_server}historical_layers ORDER BY timestamp DESC LIMIT $HistoricalMapNumber;"))
HistoricalMapTime=($($mysql_cmd "SELECT DATE_FORMAT(timestamp, '%H:%i:%s') FROM ${db_server}historical_layers ORDER BY timestamp DESC LIMIT $HistoricalMapNumber;"))

# 检查数组是否为空
if [ ${#HistoricalMapName[@]} -eq 0 ]; then
	$CMDSH AdminBroadcast ${player_name}，未能查询到历史地图数据！
	exit
else
	# 数组不为空时，遍历数组并打印每个元素
	for i in "${!HistoricalMapName[@]}"; do
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminBroadcast 历史地图：【${i}】-【${HistoricalMapName[i]}】-【${HistoricalMapTime[i]}】 " ok
	done
fi

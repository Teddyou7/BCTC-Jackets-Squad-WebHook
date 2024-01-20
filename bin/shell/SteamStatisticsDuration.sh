#!/bin/bash
#SteamStatisticsDuration.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/SteamStatisticsDuration
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.steamID}}%%{{player.name}}%%{{player.sessionDuration}}%%{{player.server.timePlayed}}%%{{player.org.timePlayed}}%%1" 
# }
#}
#
#Version 1.0;2023/11/30 23:18;Teddyou；游戏时长主动查询

#name
player_name=`echo $1|awk -F '%%' '{print $2}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $1}'`
#ServerID
ServerID=`echo $1|awk -F '%%' '{print $6}'`
player_sessionDuration=`echo $1|awk -F '%%' '{print $3}'`
player_server_timePlayed=`echo $1|awk -F '%%' '{print $4}'`
player_org_timePlayed=`echo $1|awk -F '%%' '{print $5}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

organizational_duration=$((player_sessionDuration + player_org_timePlayed))

# 将总时间转换为以两位小数显示的小时数
total_time_hours=$(echo "scale=2; $organizational_duration / 3600" | bc)

# 服务器时长，使用 `printf "%.2f"` 格式化输出，确保小数部分有两位数字，包括首位为零
formatted_output=$(printf "%.2f" $total_time_hours)

steam_duration=`${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${steamID}`
steam_duration_tmp=$(echo "scale=2;$steam_duration / 60"|bc)
steam_duration_output=$(printf "%.2f" $steam_duration_tmp)

if [ -z "$BMAPITOKEN" ]; then
	if [ "$steam_duration" == "null" ];then
		$CMDSH AdminBroadcast ${player_name}，Steam资料未公开，已累计在${Org}游玩${formatted_output}小时。
		exit
	else
		$CMDSH AdminBroadcast ${player_name}，Steam游戏时长为${steam_duration_output}小时，已累计在${Org}游玩${formatted_output}小时。
		exit
	fi
fi

# 提取账户创建时间
Timecreated=$(${WBHKHOME}/bin/shell/additional/QueryAllSteamUserInformation.sh $steamID timecreated)
# 提取拥有的游戏数量
Gamecount=$(${WBHKHOME}/bin/shell/additional/QueryAllSteamUserInformation.sh $steamID gamecount)
# 提取所有游戏的游玩时间总和
Playtime=$(${WBHKHOME}/bin/shell/additional/QueryAllSteamUserInformation.sh $steamID playtime)
steam_all_duration=$(echo "scale=2;$Playtime / 60"|bc)

`date -d @${Timecreated} +"%Y/%m/%d %H:%M"`

if [ "$steam_duration" == "null" ];then
	$CMDSH AdminBroadcast ${player_name}，Steam资料未公开，已累计在${Org}游玩${formatted_output}小时。
	exit
else
	if [ "$Gamecount" == "null" ];then
		$CMDSH AdminBroadcast ${player_name}，账号创建于`date -d @${Timecreated} +"%Y/%m/%d %H:%M"`，Squad时长为${steam_duration_output}小时，已累计在${Org}游玩${formatted_output}小时。
	else
		$CMDSH AdminBroadcast ${player_name}，账号创建于`date -d @${Timecreated} +"%Y/%m/%d %H:%M"`，Squad时长为${steam_duration_output}小时，Steam累计游戏时长为${steam_all_duration}小时，拥有${Gamecount}款游戏，已累计在${Org}游玩${formatted_output}小时。
		exit
	fi
fi

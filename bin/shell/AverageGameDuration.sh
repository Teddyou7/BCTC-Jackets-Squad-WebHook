#!/bin/bash
#AverageGameDuration.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/AverageGameDuration
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.name}}%%{{player.steamID}}%%1" 
# }
#}
#
#Version 1.0;2023/10/31 12:59;Teddyou；对局平均时长查询

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#ServerID
ServerID=`echo $1|awk -F '%%' '{print $3}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

$CMDSH AdminBroadcast $player_name，正在查询双方阵营的平均时长，请稍后。

DATE=`date +"%s"`

FILE="${WBHKHOME}/date/tmp/RconQueryCache/TeamDuration.$DATE"

${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID

PLAYER641=(`cat $FILE|grep 'Squad ID'|grep 'Team ID: 1'|awk '{print $9}'`)
PLAYER642=(`cat $FILE|grep 'Squad ID'|grep 'Team ID: 2'|awk '{print $9}'`)

PLAYERSUM1=`echo ${#PLAYER641[@]}`
if [ "$PLAYERSUM1" -eq 0 ];then
  $CMDSH AdminBroadcast $player_name，获取Team1玩家列表失败或阵营人数为空，请再次尝试。
  exit
fi

PLAYERSUM2=`echo ${#PLAYER642[@]}`
if [ "$PLAYERSUM2" -eq 0 ];then
  $CMDSH AdminBroadcast $player_name，获取Team2玩家列表失败或阵营人数为空，请再次尝试。
  exit
fi

#计算Team1
for I in ${!PLAYER641[@]}
do
	${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${PLAYER641[${I}]} |grep -v null >> ${WBHKHOME}/date/tmp/AverageGameDuration/team1.$DATE
done
Team1min=`cat ${WBHKHOME}/date/tmp/AverageGameDuration/team1.$DATE | awk '{sum+=$1} END {print "", sum/NR}'`

#计算Team1
for I in ${!PLAYER642[@]}
do
	${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${PLAYER642[${I}]} |grep -v null >> ${WBHKHOME}/date/tmp/AverageGameDuration/team2.$DATE
done
Team2min=`cat ${WBHKHOME}/date/tmp/AverageGameDuration/team2.$DATE | awk '{sum+=$1} END {print "", sum/NR}'`

Team1minH=`echo "scale=2;${Team1min} / 60"|bc`
Team2minH=`echo "scale=2;${Team2min} / 60"|bc`

SUM=`cat ${WBHKHOME}/date/tmp/AverageGameDuration/team1.$DATE ${WBHKHOME}/date/tmp/AverageGameDuration/team2.$DATE |wc -l`

$CMDSH AdminBroadcast $player_name，已查询到Team1阵营steam平均时长${Team1minH}小时，Team2阵营steam平均时长${Team2minH}小时；当前服务器已公开资料${SUM}人。
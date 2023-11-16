#!/bin/bash
#TeamDuration.sh
#小队时长查询接口，队长调用，返回自己小队所有人的时长信息。
#  "content":"{{player.name}}%%{{player.steamID}}%%{{server.name}}"

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#ServerID
ServerID=`echo $1|awk -F '%%' '{print $3}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

DATE=`date +'%H%M%S.%N'`

FILE="${WBHKHOME}/date/tmp/RconQueryCache/TeamDuration.$DATE"

${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID

userid=`cat $FILE|grep $steamID|awk '{print $2}'`
teamid=`cat $FILE|grep $steamID|awk -F "Team ID: " '{print $2}'|awk '{print $1}'`
squadid=`cat $FILE|grep $steamID|awk -F "Squad ID: " '{print $2}'|awk '{print $1}'`

users=(`cat $FILE|grep -E "\| Team ID: $teamid \| Squad ID: $squadid \|" |grep -v $steamID |awk '{print $5}'`)
usernames=(`cat $FILE|grep -E "\| Team ID: $teamid \| Squad ID: $squadid \|" |grep -v $steamID |awk -F "Name: " '{print $2}'|awk '{print $1}'`)

for I in ${!users[@]}
do
	if [ "$(${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${users[${I}]})" == "null" ];then
		$CMDSH AdminWarnById $userid ${usernames[${I}]}，因未公开资料，无法查询。
		continue
	fi
	if [ "$(${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${users[${I}]})" != "null" ];then
		$CMDSH AdminWarnById $userid ${usernames[${I}]}，查询Steam时长$(echo "scale=2;`${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${users[${I}]}` / 60"|bc)小时。
	fi
	sleep 2
done

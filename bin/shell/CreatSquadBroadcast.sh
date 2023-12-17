#!/bin/bash
#CreatSquadBroadcast.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/CreatSquadBroadcast
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.name}}%%{{player.steamID}}%%{{timestamp.iso8601}}%%{{player.teamID}}%%{{player.squadID}}%%{{msg.squadName}}%%{{player.sessionDuration}}%%{{player.server.timePlayed}}%%{{player.org.timePlayed}}%%1" 
# }
#}
#
#Version 1.1;2023/12/5 0:28;Teddyou；小队长创建小队广播

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#timestamp
timestamp_tmp=`echo $1|awk -F '%%' '{print $3}'`
#player.teamID
player_teamID_tmp=`echo $1|awk -F '%%' '{print $4}'`
#player.squadID
player_squadID_tmp=`echo $1|awk -F '%%' '{print $5}'`
#msg.squadName 
msg_squadName=`echo $1|awk -F '%%' '{print $6}'`
#时长处理
player_sessionDuration=`echo $1|awk -F '%%' '{print $7}'`
player_server_timePlayed=`echo $1|awk -F '%%' '{print $8}'`
player_org_timePlayed=`echo $1|awk -F '%%' '{print $9}'`
organizational_duration=$((player_sessionDuration + player_org_timePlayed))
total_time_hours=$(echo "scale=2; $organizational_duration / 3600" | bc)
# 得到服务器时长
formatted_output=$(printf "%.2f" $total_time_hours)

#ServerID
ServerID=`echo $1|awk -F '%%' '{print $10}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

# 将 UTC 时间字符串转换为时间戳
timestamp=$(date -d "$timestamp_tmp" +%s.%N)
# 将时间戳转换为北京时间字符串，只保留小数点后3位；获取小队创建时间
beijing_time=$(TZ='Asia/Shanghai' date -d "@$timestamp" +"%H:%M:%S.%N" | cut -c1-12)
# 将时间戳转换为北京时间戳
beijing_timestamp=$(TZ='Asia/Shanghai' date -d "@$timestamp" +%s.%N)

DATE=`date +"%s"`
FILE="${WBHKHOME}/date/tmp/RconQueryCache/CreatSquadBroadcast.$DATE"

FILE_TMP="${WBHKHOME}/date/tmp/CreatSquadInfo/CreatSquad.info"

#判断小队ID是否正确
if [[ "$player_squadID_tmp" =~ ^[0-9]+$ ]]; then
	player_squadID=$player_squadID_tmp
	echo "player_squadID is ok!"
else
	#小队ID不正确，重新取值
	${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID
	sleep 1
	player_squadID=`cat $FILE|grep $steamID | grep -oP 'Squad ID: \K\d+'`
fi

#判断阵营ID是否正确
if [[ "$player_teamID_tmp" =~ ^[0-9]+$ ]]; then
	player_teamID=$player_teamID_tmp
	echo "player_teamID is ok!"
else
	#阵营ID不正确，重新取值
	${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID
	sleep 1
	player_teamID=`cat $FILE|grep $steamID | grep -oP 'Team ID: \K\d+'`
fi

#判断小队ID是否正确
if [[ "$player_squadID_tmp" =~ ^[0-9]+$ ]]; then
    player_squadID=$player_squadID_tmp
    echo "player_squadID is ok!"
	#squadid|squadname|name|steamid|teamid|time
	echo "${player_squadID}s${player_teamID}t%%${player_name}%%${steamID}%%${msg_squadName}%%${beijing_timestamp}" >> $FILE_TMP
else
    #小队ID不正确，重新取值
    MAX_RETRIES=10  # 最大重试次数
    RETRY_COUNT=0
    while [[ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]]; do
        ${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID
        sleep 1
        player_squadID=$(cat $FILE | grep $steamID | grep -oP 'Squad ID: \K\d+')

        if [[ "$player_squadID" =~ ^[0-9]+$ ]]; then
            echo "Successfully retrieved player_squadID: $player_squadID"
			#squadid|squadname|name|steamid|teamid|time
            echo "${player_squadID}s${player_teamID}t%%${player_name}%%${steamID}%%${msg_squadName}%%${beijing_timestamp}" >> $FILE_TMP
            break  # 跳出循环
        else
            echo "Failed to retrieve player_squadID. Retrying..."
            RETRY_COUNT=$((RETRY_COUNT+1))
            sleep 1
        fi
    done

    if [[ "$RETRY_COUNT" -eq "$MAX_RETRIES" ]]; then
        echo "Exceeded maximum retries. Could not retrieve player_squadID. SquadID=0"
		#squadid|squadname|name|steamid|teamid|time
        echo "0s${player_teamID}t%%${player_name}%%${steamID}%%${msg_squadName}%%${beijing_timestamp}" >> $FILE_TMP
    fi
fi

#开始处理广播内容
if [ "$CreatSquad_BroadcastMODE" -eq 0 ]; then
    # 处理 CreatSquad_BroadcastMODE 为 0 的逻辑
    echo "CreatSquad_BroadcastMODE is 0."
	exit
elif [ "$CreatSquad_BroadcastMODE" -eq 1 ]; then
    # 处理 CreatSquad_BroadcastMODE 为 1 的逻辑
    echo "CreatSquad_BroadcastMODE is 1."
	steam_duration=`${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${steamID}`
	if [ "$steam_duration" == "null" ];then
		$CMDSH AdminBroadcast [${beijing_time}][${player_teamID}-${player_squadID}]“${player_name}”创建小队，Steam资料未公开，已累计在${Org}游玩${formatted_output}小时。
		exit
	else
		steam_duration_tmp=$(echo "scale=2;$steam_duration / 60"|bc)
		steam_duration_output=$(printf "%.2f" $steam_duration_tmp)
		$CMDSH AdminBroadcast [${beijing_time}][${player_teamID}-${player_squadID}]“${player_name}”创建小队，Steam游戏时长为${steam_duration_output}小时。
		exit
	fi
elif [ "$CreatSquad_BroadcastMODE" -eq 2 ]; then
    # 处理 CreatSquad_BroadcastMODE 为 2 的逻辑
	steam_duration=`${WBHKHOME}/bin/shell/additional/SteamDuration.sh ${steamID}`
	if [ "$steam_duration" == "null" ];then
		exit
	else
		echo "CreatSquad_BroadcastMODE is 2."
		steam_duration_tmp=$(echo "scale=2;$steam_duration / 60"|bc)
		steam_duration_output=$(printf "%.2f" $steam_duration_tmp)
		if [ "$steam_duration" -lt "$SLSteamDuration" ]; then
			$CMDSH AdminBroadcast [${beijing_time}][${player_teamID}-${player_squadID}]检查到“${player_name}”创建[${msg_squadName}]，Steam时长低于设定值，时长为${steam_duration_output}小时，请服务器管理员处理。
		fi
		exit
	fi
else
    # 默认情况，当 CreatSquad_BroadcastMODE 不匹配任何选项时的逻辑
    echo "Invalid CreatSquad_BroadcastMODE value. Config Err!!!"
	exit
fi

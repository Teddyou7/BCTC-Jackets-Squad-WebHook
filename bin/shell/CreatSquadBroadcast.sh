#!/bin/bash
#CreatSquadBroadcast.sh
#${WBHKHOME}/bin/shell/CreatSquadBroadcast.sh $steamid $player_name $squad_name $utc_plus_8_milliseconds $team_id $squad_id

steamID=$1
player_name=$2
squad_name=$3
utc_plus_8_milliseconds=$4
utc_plus_8=$(echo $utc_plus_8_milliseconds | awk '{print $2}')
team_id=$5
squad_id=$6

#ServerID
ServerID=`echo $1|awk -F '%%' '{print $10}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh


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
		$CMDSH AdminBroadcast [${utc_plus_8}][${team_id}-${squad_id}]“${player_name}”创建小队，Steam资料未公开。
		exit
	else
		steam_duration_tmp=$(echo "scale=2;$steam_duration / 60"|bc)
		steam_duration_output=$(printf "%.2f" $steam_duration_tmp)
		$CMDSH AdminBroadcast [${utc_plus_8}][${team_id}-${squad_id}]“${player_name}”创建小队，Steam游戏时长为${steam_duration_output}小时。
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
			$CMDSH AdminBroadcast [${utc_plus_8}][${team_id}-${squad_id}]检查到“${player_name}”创建[${squad_name}]，Steam时长低于设定值，时长为${steam_duration_output}小时，请服务器管理员处理。
		fi
		exit
	fi
else
    # 默认情况，当 CreatSquad_BroadcastMODE 不匹配任何选项时的逻辑
    echo "Invalid CreatSquad_BroadcastMODE value. Config Err!!!"
	exit
fi

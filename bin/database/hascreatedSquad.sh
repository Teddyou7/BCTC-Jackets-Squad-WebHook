#!/bin/bash
#hascreatedSquad.sh

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/database//g')/cfg/config.sh
#$mysql_cmd  "INSERT INTO ${db_server}historical_layers (map_name, timestamp) VALUES ('$map_name', '$utc_plus_8_milliseconds')"

faction_name=$1

steamid=$2
player_name=$3
squad_name=$4
squad_id=$5

utc_plus_8_milliseconds=$6

#从日志获取
map_name="$( tail -100000 $SquadGameLog | grep StartLoadingDestination | tail -1 | awk -F/ '{print $NF}' | tr -d '\r' )"

team_id=$(cat ${WBHKHOME}/date/mysql/layer_info.txt | tr -d '\r' | grep "${map_name}:${faction_name}" | awk -F : '{print $3}')
if [[ -z "$team_id" ]]; then
	team_id="0"
fi
#echo "Gorodok_RAAS_v05:UnitedStatesArmy:1" >> /Jackets/bctc/server4/date/mysql/layer_info.txt
# 插入数据到squad_creation_info表
$mysql_cmd  "INSERT INTO ${db_server}squad_creation_info (leader_steamid, leader_nickname, squad_name, team_id, squad_id, creation_time) VALUES ('$steamid', '$player_name', '$squad_name', '$team_id', '$squad_id', '$utc_plus_8_milliseconds')"

${WBHKHOME}/bin/shell/CreatSquadBroadcast.sh "$steamid" "$player_name" "$squad_name" "$utc_plus_8_milliseconds" "$team_id" "$squad_id" &
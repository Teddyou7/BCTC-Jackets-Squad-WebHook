#!/bin/bash
#ActualDamage.sh

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/database//g')/cfg/config.sh
#$mysql_cmd  "INSERT INTO ${db_server}historical_layers (map_name, timestamp) VALUES ('$map_name', '$utc_plus_8_milliseconds')"

operator_steamid=$1
operator_nickname=$2
target_nickname=$3
weapon=$4
action_time=$5
damage=$6

# 查询target_steamid（如果存在）
target_steamid=$($mysql_cmd "SELECT steamid FROM ${db_server}player_stats WHERE nickname='$target_nickname' LIMIT 1;")
#if [[ -z "$target_steamid" ]]; then
#	target_steamid="$target_nickname"
#fi
# 插入数据到combat_info表
$mysql_cmd  "INSERT INTO ${db_server}combat_info (operator_steamid, operator_nickname, action, target_steamid, target_nickname, weapon, action_time ,health) VALUES ('$operator_steamid', '$operator_nickname', 'ActualDamage', '$target_steamid', '$target_nickname', '$weapon', '$action_time', '$damage')"

${WBHKHOME}/bin/shell/AdvancedCombatInformation.sh 1 "$operator_steamid" "$operator_nickname" "$target_steamid" "$target_nickname" "$weapon" "$action_time" "$damage" &
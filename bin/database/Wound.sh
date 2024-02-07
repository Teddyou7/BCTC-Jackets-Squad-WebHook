#!/bin/bash
#Wound.sh

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/database//g')/cfg/config.sh
#$mysql_cmd  "INSERT INTO ${db_server}historical_layers (map_name, timestamp) VALUES ('$map_name', '$utc_plus_8_milliseconds')"

operator_steamid=$1
target_nickname=$2
weapon=$3
action_time=$4
damage=$5

# 查询target_steamid（如果存在）
target_steamid=$($mysql_cmd "SELECT steamid FROM ${db_server}player_stats WHERE nickname='$target_nickname' LIMIT 1;")

# 查询operator_nickname
operator_nickname=$($mysql_cmd "SELECT nickname FROM ${db_server}player_stats WHERE steamid='$operator_steamid' LIMIT 1;")

$mysql_cmd  "INSERT INTO ${db_server}combat_info (operator_steamid, operator_nickname, action, target_steamid, target_nickname, weapon, action_time ,health) VALUES ('$operator_steamid', '$operator_nickname', 'Wound', '$target_steamid', '$target_nickname', '$weapon', '$action_time', '$damage')"

${WBHKHOME}/bin/shell/AdvancedCombatInformation.sh 2 "$operator_steamid" "$operator_nickname" "$target_steamid" "$target_nickname" "$weapon" "$action_time" "$damage" &
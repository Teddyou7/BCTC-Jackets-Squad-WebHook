#!/bin/bash
#hasrevived.sh

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/database//g')/cfg/config.sh
#$mysql_cmd  "INSERT INTO ${db_server}historical_layers (map_name, timestamp) VALUES ('$map_name', '$utc_plus_8_milliseconds')"

operator_steamid=$1
operator_nickname=$2
target_steamid=$3
target_nickname=$4
weapon=$5
action_time=$6
damage=$7

$mysql_cmd  "INSERT INTO ${db_server}combat_info (operator_steamid, operator_nickname, action, target_steamid, target_nickname, weapon, action_time ,health) VALUES ('$operator_steamid', '$operator_nickname', 'revived', '$target_steamid', '$target_nickname', '$weapon', '$action_time', '$damage')"


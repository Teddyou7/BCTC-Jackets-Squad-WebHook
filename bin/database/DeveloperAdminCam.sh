#!/bin/bash
#DeveloperAdminCam.sh

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/database//g')/cfg/config.sh
#$mysql_cmd  "INSERT INTO ${db_server}historical_layers (map_name, timestamp) VALUES ('$map_name', '$utc_plus_8_milliseconds')"

operator_steamid=$1
operator_nickname=
Possess=
target_nickname=$2
weapon=$3
action_time=$4

$mysql_cmd  "INSERT INTO ${db_server}combat_info (operator_steamid, operator_nickname, action, target_nickname, weapon, action_time ,health) VALUES ('$operator_steamid', '$operator_nickname', '$Possess', '$target_nickname', '$weapon', '$action_time', '0')"

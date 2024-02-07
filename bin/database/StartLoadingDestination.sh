#!/bin/bash
#StartLoadingDestination.sh

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/database//g')/cfg/config.sh
#$mysql_cmd  "INSERT INTO ${db_server}historical_layers (map_name, timestamp) VALUES ('$map_name', '$utc_plus_8_milliseconds')"

map_name=$1
utc_plus_8_milliseconds=$2

$mysql_cmd  "INSERT INTO ${db_server}historical_layers (map_name, timestamp) VALUES ('$map_name', '$utc_plus_8_milliseconds')"

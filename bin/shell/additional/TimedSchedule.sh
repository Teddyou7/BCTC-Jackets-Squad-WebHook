#!/bin/bash
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

while true
do
	#steam游戏时长缓存
	find ${WBHKHOME}/date/tmp/SteamDuration/ -type f -mmin +${SteamDurationTmpMin} -delete
	#RconQueryCache查询缓存
	find ${WBHKHOME}/date/tmp/RconQueryCache/ -type f -mmin +60 -delete
	find ${WBHKHOME}/logs/RconLog/ -type f -mmin +60 -delete
	sleep 120
done
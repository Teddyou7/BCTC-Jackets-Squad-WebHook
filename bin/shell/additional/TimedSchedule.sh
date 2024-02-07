#!/bin/bash
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

while true
do
	#steam游戏时长缓存
	find ${WBHKHOME}/date/tmp/SteamDuration/ -type f -mmin +${SteamDurationTmpMin} -delete
	#RconQueryCache查询缓存
	find ${WBHKHOME}/date/tmp/RconQueryCache/ -type f -mmin +60 -delete
	find ${WBHKHOME}/logs/RconLog/ -type f -mmin +60 -delete
	find ${WBHKHOME}/date/tmp/PlayerGameID/ -type f -mmin +20 -delete
	find ${WBHKHOME}/date/tmp/PlayerListSnapshots/ -type f -mmin +180 -delete
	find ${WBHKHOME}/date/tmp/CreatSquadInfo/ -type f -mmin +120 -delete
	find ${WBHKHOME}/date/tmp/AdvancedCombatInformation/ -type f -mmin +${AdvancedCombatInformationTime} -delete
	find ${WBHKHOME}/date/tmp/HotSearchFiles/ -type f -mmin +180 -delete
	sleep 120
done

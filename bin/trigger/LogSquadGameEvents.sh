#!/bin/bash
#LogSquadGameEvents.sh
#自动跳过结束等待

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/trigger//g')/cfg/config.sh

if [ -z "$BCTC_LogSquadGameEventsIf" ]; then
    exit 1
fi

if [ $BCTC_LogSquadGameEventsIf -eq 0 ];then
	exit
fi

# 实时监控日志文件
tail -f "$SquadGameLog" | while read line; do
    if echo "$line" | grep "LogSquadGameEvents: Display: Team 1"; then
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminSlomo ${EndMatchTimeMultiplier}" ok
    fi
done

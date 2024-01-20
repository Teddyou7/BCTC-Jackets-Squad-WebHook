#!/bin/bash
#StartLoadingDestination.sh
#开局加速跳过

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/trigger//g')/cfg/config.sh

if [ -z "$BCTC_TrainingMatchIf" ]; then
    echo "参数为空，脚本退出。"
    exit 1
fi

if [ $BCTC_TrainingMatchIf -eq 0 ];then
	exit
fi

# 实时监控日志文件
tail -f "$SquadGameLog" | while read line; do
    if echo "$line" | grep "StartLoadingDestination"; then
		sleep 8
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceAllVehicleAvailability 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceAllDeployableAvailability 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceAllActionAvailability 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceAllRoleAvailability 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminDisableVehicleTeamRequirement 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminDisableVehicleKitRequirement 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminDisableVehicleClaiming 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminNoRespawnTimer 1" ok
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminSlomo 20" ok
		sleep 16
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminSlomo 1" ok
    fi
done

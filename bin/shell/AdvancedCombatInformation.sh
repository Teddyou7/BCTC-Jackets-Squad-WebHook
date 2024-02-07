#!/bin/bash
#AdvancedCombatInformation.sh

#${WBHKHOME}/bin/shell/AdvancedCombatInformation.sh 1 $operator_steamid $operator_nickname $target_steamid $target_nickname $weapon $action_time $damage
#1=ActualDamage 2=Wound,Die 3=revived

#${WBHKHOME}/bin/shell/AdvancedCombatInformation.sh 1 76561198193670050 『冲锋号』Teddyou 76561198193670050 『冲锋号』Teddyou 'Soldier RU Rifleman1 Desert' '2024-01-31 14:03:51.312' 95.529678

operateid=$1
operator_steamid=$2
operator_nickname=$3
target_steamid=$4
target_nickname=$5
weapon=$6
action_time=$7
damage=$(printf "%.2f\n" $8)

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

if [ $AdvancedCombatInformation -eq 0 ];then
	exit
fi

# 定义文件路径
file_operator="${WBHKHOME}/date/tmp/AdvancedCombatInformation/${operator_steamid}"
file_target="${WBHKHOME}/date/tmp/AdvancedCombatInformation/${target_steamid}"

if [ "$operateid" -eq "1" ]; then
	if [ -f "$file_operator" ]; then
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${operator_steamid} 命中【${target_nickname}】，伤害：${damage}" ok
	fi
	if [ -f "$file_target" ]; then
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${target_steamid} 被【${operator_nickname}】命中，伤害：${damage}" ok
	fi
elif [ "$operateid" -eq "2" ]; then
	if [ -f "$file_operator" ]; then
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${operator_steamid} 击倒【${target_nickname}】" ok
	fi
	if [ -f "$file_target" ]; then
		${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${target_steamid} 被【${operator_nickname}】击杀，武器【${weapon}】，伤害：${damage}" ok
	fi
fi

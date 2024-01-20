#!/bin/bash
#CombatInformation.sh
#战斗信息入库
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/trigger//g')/cfg/config.sh
#伤害
#[2024.01.18-15.06.27:688][ 88]LogSquad: Player:•冲锋号•demons ActualDamage=25.199999 from 冲锋号A-柒七 (Online IDs: EOS: 00028141617d4341b232a64ce3d7cff6 steam: 76561199201969311 | Player Controller ID: BP_PlayerController_C_2146855813)caused by BP_AK74M_C_2146845264
#[2024.01.18-15.06.31:170][261]LogSquad: Player:冲锋号A-Xuemw ActualDamage=62.000004 from •冲锋号•大傻春 (Online IDs: EOS: 00021b250cdd45a29a11a4843e34566b steam: 76561199350178135 | Player Controller ID: BP_PlayerController_C_2146855477)caused by BP_M4A1_M68_Foregrip_Tracer_C_2146846074
#[2024.01.18-15.06.31:599][282]LogSquad: Player:冲锋号A-Xuemw ActualDamage=96.000015 from •冲锋号•大傻春 (Online IDs: EOS: 00021b250cdd45a29a11a4843e34566b steam: 76561199350178135 | Player Controller ID: BP_PlayerController_C_2146855477)caused by BP_M4A1_M68_Foregrip_Tracer_C_2146846074

#阵亡
#[2024.01.18-15.06.31:599][282]LogSquad: Player:冲锋号A-Xuemw ActualDamage=96.000015 from •冲锋号•大傻春 (Online IDs: EOS: 00021b250cdd45a29a11a4843e34566b steam: 76561199350178135 | Player Controller ID: BP_PlayerController_C_2146855477)caused by BP_M4A1_M68_Foregrip_Tracer_C_2146846074
#echo '[2024.01.18-15.06.31:599][282]LogSquadTrace: [DedicatedServer]Wound(): Player:冲锋号A-Xuemw KillingDamage=96.000015 from BP_PlayerController_C_2146855477 (Online IDs: EOS: 00021b250cdd45a29a11a4843e34566b steam: 76561199350178135 | Controller ID: BP_PlayerController_C_2146855477) caused by BP_M4A1_M68_Foregrip_Tracer_C_2146846074' | grep -oP 'ActualDamage=\K[0-9]+\.[0-9]+'

ServerIP="127.0.0.1"
RconPort=21114
RconPasswd="ouyangwenguang"
SquadGameLog="/home/steam/squad_server/SquadGame/Saved/Logs/SquadGame.log"
# 实时监控日志文件
tail -f "$SquadGameLog" | while read line; do
    if echo "$line" | grep "ActualDamage"; then
        actual_damage=$(echo "$line" | grep -oP 'ActualDamage=\K[0-9]+\.[0-9]+')
        formatted_damage=$(printf "%.1f" $actual_damage)
        steam_id=$(echo "$line" | grep -oP 'steam: \K[0-9]+')
        player_name=$(echo "$line" | grep -oP 'Player:\K\S+')
		attacker_name=$(echo $line |grep -oP 'from \K.*(?= \(Online IDs)' )
		/usr/local/bin/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${steam_id} 命中【${player_name}】，伤害：${formatted_damage} " ok
		/usr/local/bin/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${player_name} 被【${attacker_name}】命中，伤害：${formatted_damage} " ok
    fi
	if echo "$line" | grep "Wound"; then
		# 使用grep和awk提取指定的数据
		steam_id=$(echo $line | grep -oP 'steam: \K[0-9]+')
		weapon_info=$(echo $line |grep -oP 'caused by \K[\w_\-]+')
		#player_name=$(echo "$line" | grep -oP 'Player:\K\S+')
		line2=$(cat $SquadGameLog |grep ActualDamage | grep $weapon_info | tail -1)
		# 使用grep提取ActualDamage值
		actual_damage=$(echo $line2 | grep -oP 'ActualDamage=\K[0-9]+\.[0-9]+')
		formatted_damage=$(printf "%.1f" $actual_damage)
		# 使用grep提取玩家名称
		player_name=$(echo $line2 |grep -oP 'Player:\K[^ ]+')
		# 使用grep提取特定的玩家名
		attacker_name=$(echo $line2 |grep -oP 'from \K.*(?= \(Online IDs)' )
		attacker_steam_id=$(echo $line2 |grep -oP 'steam: \K[0-9]+')
		weapon=$(echo $weapon_info | awk -F '_' '{print $2}')
		/usr/local/bin/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${player_name} 被【${attacker_name}】击杀，武器【${weapon}】，伤害：${formatted_damage} " ok
		/usr/local/bin/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarn ${attacker_steam_id} 击杀：${player_name} " ok
		/usr/local/bin/mcrcon -H ${ServerIP} -P ${RconPort} -p ${RconPasswd} "AdminBroadcast 【${attacker_name}】-->${weapon}(${formatted_damage})-->【${player_name}】" ok
    fi
done

#此处后方显示攻击者64id
#[2024.01.18-15.50.32:391][264]LogSquadTrace: [DedicatedServer]Wound(): Player:•冲锋号•大傻春 KillingDamage=62.000004 from BP_PlayerController_C_2146852642 (Online IDs: EOS: 0002daa6839c4837a8b9dadf8b758eeb steam: 76561198193670050 | Controller ID: BP_PlayerController_C_2146852642) caused by BP_M4_M150_C_2146821634


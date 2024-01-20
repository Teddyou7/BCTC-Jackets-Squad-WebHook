#!/bin/bash
# TrainingActualDamageTick.sh
# 伤害检测并自动踢出

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/trigger//g')/cfg/config.sh

if [ -z "$BCTC_TrainingActualDamageIf" ]; then
    echo "参数为空，脚本退出。"
    exit 1
fi

if [ $BCTC_TrainingActualDamageIf -eq 0 ];then
    exit
fi

# 实时监控日志文件
tail -f "$SquadGameLog" | while read line; do
    if echo "$line" | grep -v 'UH60\|SA330\|MI8\|MI17\|CH146\|BP_MRH90_Mag58\|Z8G\|UH1Y\|Z8J\|UH1H\|null' | grep -E 'ActualDamage' ; then
        # 提取攻击者和被攻击者的昵称
        attacker=$(echo "$line" | grep -oP '(?<=from ).+?(?=\s\()')
        victim=$(echo "$line" | grep -oP '(?<=Player:).+?(?= ActualDamage)')

        # 检查攻击者和被攻击者是否相同
        if [ "$attacker" == "$victim" ]; then
            continue
        fi

        # 提取攻击者的 Steam ID
        steamid=$(echo "$line" | grep -oP '(?<=steam: )\d+')

        # 执行踢出操作
        $CMDSH AdminKick "$steamid" 训练场禁止对玩家造成伤害 
		$CMDSH AdminBroadcast 检查到“${attacker}”对“${victim}”造成伤害，已被踢出警告。
    fi
done

#!/bin/bash
#TrainingTurretTick.sh
#炮手位检测并踢出

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/trigger//g')/cfg/config.sh

if [ -z "$BCTC_TrainingTurretIf" ]; then
    echo "参数为空，脚本退出。"
    exit 1
fi

if [ $BCTC_TrainingTurretIf -eq 0 ];then
	exit
fi

# 实时监控日志文件
tail -f "$SquadGameLog" | while read line; do
    if echo "$line" | grep -vE Doorgun\|health\|TakeDamage\|'Seat Number' | grep -iE Turret\|CROWS\|Baseplate\|Tripod\|23Vehicle ; then
		turret=$(echo "$line" | grep -oP '(?<=\(\)\: PC=).+?(?= \(Online)')
		steamid=$(echo "$line" | grep -oP '(?<=steam: )\d+')
		# 执行踢出操作
        $CMDSH AdminKick "$steamid" 训练场禁止使用炮手位置或固定武器
		$CMDSH AdminBroadcast 检查到“${turret}”使用固定武器或载具炮手位置，已被踢出警告。
    fi
done

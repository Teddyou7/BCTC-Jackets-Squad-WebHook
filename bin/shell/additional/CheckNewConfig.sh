#!/bin/bash
#CheckNewConfig.sh
#自动更新增强程序，自动检查并添加参数
#仅支持20240205之后增加的参数

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

function_config_file="${WBHKHOME}/cfg/function_config.sh"
db_config_file="${WBHKHOME}/cfg/db_config.sh"
api_config_file="${WBHKHOME}/cfg/api_config.sh"
system_config_file="${WBHKHOME}/cfg/system_config.sh"

if ! grep -q "PlayerSpeakerSwitch" ${function_config_file}; then
	echo '#是否开启玩家喇叭喊话功能 0=关' >> ${function_config_file}
	echo 'PlayerSpeakerSwitch=1' >> ${function_config_file}
fi

if ! grep -q "HistoricalMapSwitch" ${function_config_file}; then
	echo '#历史地图开关 0=关' >> ${function_config_file}
	echo 'HistoricalMapSwitch=1' >> ${function_config_file}
fi

if ! grep -q "HistoricalMapNumber" ${function_config_file}; then
	echo '#历史地图显示地图数量' >> ${function_config_file}
	echo 'HistoricalMapNumber=5' >> ${function_config_file}
fi

if ! grep -q "ChangeCampSwitch" ${function_config_file}; then
	echo '#积分跳边开关 0=关' >> ${function_config_file}
	echo 'ChangeCampSwitch=1' >> ${function_config_file}
fi

if ! grep -q "ChangeCampName" ${function_config_file}; then
	echo '#积分跳边触发词汇（默认通用强制词汇为 !tb ）' >> ${function_config_file}
	echo 'ChangeCampName='积分跳边'' >> ${function_config_file}
fi

if ! grep -q "ChangeCampPoints" ${function_config_file}; then
	echo '#积分跳边费用，支持小数（小数使用引号）' >> ${function_config_file}
	echo 'ChangeCampPoints="8.88"' >> ${function_config_file}
fi

if ! grep -q "ChangeCampCD" ${function_config_file}; then
	echo '#积分跳边冷却时间(分钟)' >> ${function_config_file}
	echo 'ChangeCampCD=10' >> ${function_config_file}
fi

if ! grep -q "DailyFortuneFate" ${function_config_file}; then
	echo '#额外奖励积分的气运' >> ${function_config_file}
	echo 'DailyFortuneFate="财运"' >> ${function_config_file}
fi

if ! grep -q "DailyFortuneFateCD" ${function_config_file}; then
	echo '#额外奖励积分冷却时间（分钟）' >> ${function_config_file}
	echo 'DailyFortuneFateCD=720' >> ${function_config_file}
fi

if ! grep -q "DailyFortuneFatePoints" ${function_config_file}; then
	echo '#额外奖励积分数额' >> ${function_config_file}
	echo 'DailyFortuneFatePoints="8.88"' >> ${function_config_file}
fi

if ! grep -q "RandomlySelectAdministratorsSwitch" ${function_config_file}; then
	echo '#随机选择管理员功能开关 0=关' >> ${function_config_file}
	echo 'RandomlySelectAdministratorsSwitch=1' >> ${function_config_file}
fi

#if ! grep -q "" ${function_config_file}; then
#	echo '' >> ${function_config_file}
#	echo '' >> ${function_config_file}
#fi

#if ! grep -q "" ${function_config_file}; then
#	echo '' >> ${function_config_file}
#	echo '' >> ${function_config_file}
#fi

#if ! grep -q "" ${function_config_file}; then
#	echo '' >> ${function_config_file}
#	echo '' >> ${function_config_file}
#fi

#if ! grep -q "" ${function_config_file}; then
#	echo '' >> ${function_config_file}
#	echo '' >> ${function_config_file}
#fi



#!/bin/bash
#AdminCamCheck.sh
#检查飞天摄像头
#通过LogSquadGameEvents.sh调用

# 数据库配置
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

if [ "$AdminCamCheck" -eq "0" ]; then
	exit
fi

sleep 60

# 1. 查询使用AdminCam的所有不重复的operator_steamid
query="SELECT DISTINCT operator_steamid FROM ${db_server}combat_info_1 WHERE weapon='AdminCam';"
operator_ids=( $($mysql_cmd "$query") )

# 2. 对于每个operator_steamid，执行进一步的查询
for id in "${operator_ids[@]}"; do
    # 查询该用户最早的AdminCam记录
    query_first_admincam="SELECT action_time FROM ${db_server}combat_info_1 WHERE operator_steamid='$id' AND weapon='AdminCam' ORDER BY action_time ASC LIMIT 1;"
    first_time=$($mysql_cmd "$query_first_admincam")

    # 检查是否有非AdminCam记录的项目
    query_non_admincam="SELECT operator_steamid, operator_nickname, action, target_steamid, target_nickname, weapon, health, action_time FROM ${db_server}combat_info_1 WHERE operator_steamid='$id' AND weapon!='AdminCam' AND action_time > '$first_time';"
    non_admincam_records=$($mysql_cmd "$query_non_admincam")

    # 如果存在非AdminCam记录，则导出为CSV
    if [ ! -z "$non_admincam_records" ]; then
		current_time=$(date +"%Y%m%d%H%M%S")
        # 定义中文表头
        #csv_header="操作者SteamID,操作者昵称,行动,目标SteamID,目标昵称,武器,健康值,行动时间"
        echo "操作者SteamID,操作者昵称,行动,目标SteamID,目标昵称,武器,健康值,行动时间" > ${WBHKHOME}/date/tmp/AdminCamCheck/${id}_non_admincam_records_${current_time}.csv
		all_query_non_admincam="SELECT operator_steamid, operator_nickname, action, target_steamid, target_nickname, weapon, health, action_time FROM ${db_server}combat_info_1 WHERE operator_steamid='$id';"
		all_non_admincam_records=$($mysql_cmd "$all_query_non_admincam")
        echo "$all_non_admincam_records" >> ${WBHKHOME}/date/tmp/AdminCamCheck/${id}_non_admincam_records_${current_time}.csv
		
		if [ "$AdminCamCheckProcessingMethod" -eq "1" ]; then
			$CMDSH AdminKick $id 检查到在上一局对局中存在使用摄像头后战斗的行为
		elif [ "$AdminCamCheckProcessingMethod" -eq "2" ]; then
			$CMDSH AdminBan 1d $id 检查到在上一局对局中存在使用摄像头后战斗的行为
		fi
		#发送邮件
		python3 ${WBHKHOME}/bin/python/AdminCamCheckToMail.py "${id}" "$AdminCamNoticeMail" "${WBHKHOME}/cfg/mail_config.py" "${WBHKHOME}/date/tmp/AdminCamCheck/${id}_non_admincam_records_${current_time}.csv"
    fi
done

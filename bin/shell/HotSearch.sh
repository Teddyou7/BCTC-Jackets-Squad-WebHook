#!/bin/bash
# HotSearch.sh
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
ServerID=$(echo $1|awk -F '%%' '{print $3}')

if [ $HotSearchSwitch -eq 0 ] ; then
	$CMDSH AdminWarn $player_steamID 本服务器管理员已禁用每日头条功能。
	exit
fi

#生成每小时缓存
DATE_YMDH=`date +"%Y%m%d%H"`
HotSearchFiles="${WBHKHOME}/date/tmp/HotSearchFiles/$DATE_YMDH"

# 检查文件是否存在并且行数是否大于300
if [ -f "$HotSearchFiles" ]; then
    lines=$( cat "$HotSearchFiles" | jq | wc -l ) # 获取文件行数
    if [ "$lines" -gt 300 ]; then
        echo "HotSearchFiles check ok!"
    else
        # 文件存在但行数不大于300，执行curl命令更新数据
        curl -s https://open.tophub.today/hot > "$HotSearchFiles"
        echo "文件已更新。"
		sleep 1
        # 再次检查更新后的文件行数
        new_lines=$( cat "$HotSearchFiles" | jq | wc -l )
        if [ "$new_lines" -le 300 ]; then
            $CMDSH AdminWarn $player_steamID 功能使用失败，每日头条功能疑似异常，请联系管理员处理。
            exit 0
        fi
    fi
else
    # 文件不存在，执行curl命令创建并获取数据
    curl -s https://open.tophub.today/hot > "$HotSearchFiles"
    echo "文件已创建并更新。"
	sleep 1
    # 检查新创建的文件行数
    new_lines=$( cat "$HotSearchFiles" | jq | wc -l )
    if [ "$new_lines" -le 300 ]; then
        $CMDSH AdminWarn $player_steamID 功能使用失败，每日头条功能疑似异常，请联系管理员处理。
        exit 0
    fi
fi

isNotZero=$(echo "$HotSearchPoints != 0" | bc)
# 检查是否设置收费
if [ $isNotZero -eq 1 ]; then
	#判断当前积分是否足够
	CurrentBalance=$($mysql_cmd "SELECT current_balance FROM transactions WHERE steamid='$player_steamID' AND organization_tag='$db_tag' ORDER BY transaction_time DESC LIMIT 1;")
	if [ $(echo "$CurrentBalance >= $HotSearchPoints" | bc) -eq 1 ]; then
		Balance=$(${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$player_steamID" "del" "${HotSearchPoints}" "通过热搜头条搜索消耗")
		$CMDSH AdminWarn $player_steamID 功能使用，已扣除${HotSearchPoints}${PointsName}，当前剩余$Balance
	else
		$CMDSH AdminWarn $player_steamID 每日头条查询失败，需要${HotSearchPoints}${PointsName}，当前剩余$CurrentBalance
		exit
	fi
fi


# 将JSON文件内容读取到变量中
json_data=$(cat $HotSearchFiles)

# 使用jq获取简报的数量
count=$(echo "$json_data" | jq '.data.items | length')

# 生成一个随机数
random_index=$(($RANDOM % $count))

# 使用jq提取随机选中的简报的标题和URL
title=$(echo "$json_data" | jq -r --argjson index $random_index '.data.items[$index].title')
sitename=$(echo "$json_data" | jq -r --argjson index $random_index '.data.items[$index].sitename')
views=$(echo "$json_data" | jq -r --argjson index $random_index '.data.items[$index].views')

#消息拼接
HotSearchText="$random_index.$title[$sitename-$views]"
HotSearchTextS="${HotSearchText// /}"

$CMDSH AdminBroadcast 为“$player_name”查询到的热搜头条：$HotSearchTextS


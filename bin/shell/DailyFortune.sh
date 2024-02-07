#!/bin/bash
# DailyFortune.sh
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
ServerID=$(echo $1|awk -F '%%' '{print $3}')

usersteamid=$player_steamID
token=$BAIDUAPIAK

if [ $DailyFortuneSwitch -eq 0 ] ; then
	$CMDSH AdminWarn $player_steamID 本服务器管理员已禁用每日运势查询。
	exit
fi

isNotZero=$(echo "$DailyFortunePoints != 0" | bc)
# 检查是否设置收费
if [ $isNotZero -eq 1 ]; then
	#判断当前积分是否足够
	CurrentBalance=$($mysql_cmd "SELECT current_balance FROM transactions WHERE steamid='$player_steamID' AND organization_tag='$db_tag' ORDER BY transaction_time DESC LIMIT 1;")
	if [ $(echo "$CurrentBalance >= $DailyFortunePoints" | bc) -eq 1 ]; then
		Balance=$(${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$player_steamID" "del" "${DailyFortunePoints}" "通过每日运势消耗")
		$CMDSH AdminWarn $player_steamID 功能使用，已扣除${DailyFortunePoints}${PointsName}，当前剩余$Balance
	else
		$CMDSH AdminWarn $player_steamID 每日运势查询失败，需要${DailyFortunePoints}${PointsName}，当前剩余$CurrentBalance
		exit
	fi
fi

# 取steamid末尾九位
last_nine=${player_steamID: -9}

# 检查是否以0开头
if [[ $last_nine == 0* ]]; then
    # 将首个0替换为8
    last_nine="8${last_nine:1}"
fi

timeout=10

json_data=$(curl -s --connect-timeout $timeout https://api.fanlisky.cn/api/qr-fortune/get/$last_nine)

# 检查curl命令是否因为超时而失败
if [ $? -ne 0 ]; then
    echo "curl 命令因为超时而失败"
    Balance=$(${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$player_steamID" "add" "${RealTimeWeatherPoints}" "运势查询超时返还")
    ${CMDSH} AdminWarn "$player_steamID" "运势查询超时！积分已返还，当前余额：$Balance"
    exit
fi

# 检查城市名称是否为空
if [[ $json_data =~ null ]]; then
    #echo "错误！城市名称为空"
    Balance=$(${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$player_steamID" "add" "${RealTimeWeatherPoints}" "运势查询失败返还")
    ${CMDSH} AdminWarn "$player_steamID" "运势查询失败！积分已返还，当前余额：$Balance"
    exit
fi

code=$(echo "$json_data" | jq '.code')
status=$(echo "$json_data" | jq '.status')
msg=$(echo "$json_data" | jq '.msg')
fortuneSummary=$(echo "$json_data" | jq '.data.fortuneSummary')
id=$(echo "$json_data" | jq '.data.id')
luckyStar=$(echo "$json_data" | jq '.data.luckyStar')
signText=$(echo "$json_data" | jq '.data.signText')
unSignText=$(echo "$json_data" | jq '.data.unSignText')

#{"code":200,"status":"20011","msg":"操作成功","data":{"fortuneSummary":"凶","id":1181,"luckyStar":"★☆☆☆☆☆☆","signText":"成功虽早，慎防空亏，内外不合，障碍重重","unSignText":"事业初得成功，不能过度放松警惕，不要将积累的资本挥霍一空。如果团队里人心不能合到一起，今后做起事来也会遇到很多的阻碍。"}}

$CMDSH AdminBroadcast $player_name，查询运势：${fortuneSummary}，星级：${luckyStar}，短评：${signText}。

if [[ $fortuneSummary =~ $DailyFortuneFate ]] ; then
	DailyFortuneFateCDCheck=$($mysql_cmd "SELECT * FROM transactions WHERE transaction_time >= NOW() - INTERVAL ${DailyFortuneFateCD} MINUTE AND steamid = '$player_steamID' AND organization_tag = '$db_tag' AND note = 'DailyFortuneFate';")
	if [ -z "$DailyFortuneFateCDCheck" ]; then
		${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$player_steamID" "add" "${DailyFortuneFatePoints}" "DailyFortuneFate"
		$CMDSH AdminBroadcast $player_name，命中带${DailyFortuneFate}，额外获得${DailyFortuneFatePoints}${PointsName}。
	else
		exit
	fi
fi

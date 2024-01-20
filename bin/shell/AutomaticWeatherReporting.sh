#!/bin/bash
# AutomaticWeatherReporting.sh
# 玩家加入房间自动化天气播报脚本
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

USER_IP=$1
usersteamid=$2
token=$BAIDUAPIAK

if [ $IfWeatherBroadcast -eq 0 ] ; then
	echo "IfWeatherBroadcast is 0"
	exit
fi

# token是否为空
if [ -z "$token" ]; then
    echo "baidu token null!"
    exit
fi

# 判断是否VIP身份
IfVip=$(cat $ReservedUserInfo $SignVIPUserInfo | grep $usersteamid | wc -l)
if [ $IfVip -eq 0 ] ; then
	echo "$usersteamid no vip"
	exit
fi

# 获取用户IP的地理位置信息
json_data_baidu_ip=$(curl -s "https://api.map.baidu.com/location/ip?ip=${USER_IP}&coor=bd09ll&ak=$token")
province_ip=$(echo $json_data_baidu_ip | jq -r '.content.address_detail.province')
city_ip=$(echo $json_data_baidu_ip | jq -r '.content.address_detail.city')

# 获取区域ID
weather_district_id="${WBHKHOME}/date/BasicData/weather_district_id"
district_id=$(grep "$city_ip" "$weather_district_id" | awk '{print $1}')

# 获取天气信息
json_data_baidu=$(curl -s "https://api.map.baidu.com/weather/v1/?district_id=${district_id}&data_type=now&ak=bd09ll&ak=$token")
province=$(echo $json_data_baidu | jq -r '.result.location.province')
city=$(echo $json_data_baidu | jq -r '.result.location.city')
weather=$(echo $json_data_baidu | jq -r '.result.now.text')
temperature=$(echo $json_data_baidu | jq -r '.result.now.temp')
humidity=$(echo $json_data_baidu | jq -r '.result.now.rh')

# 检查城市名称是否为空
if [ -z "$city" ]; then
    echo "错误！城市名称为空"
    exit
fi
if [[ $city =~ null ]]; then
    echo "错误！城市名称包含 'null'"
    exit
fi


# 获取玩家名称

DATE=`date +'%H%M%S.%N'`
FILE="${WBHKHOME}/date/tmp/RconQueryCache/AutomaticWeatherReporting.$DATE"
${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID
USER_NAME=$(cat $FILE | grep "$usersteamid" | awk -F'Name: ' '/Name:/ {print $2}' | awk -F' |' '{print $1}')

# 温度和湿度阈值
LOW_TEMP_THRESHOLD=12
LOW_HUMIDITY_THRESHOLD=40

sleep 15

# 判断温度和湿度
if [[ $(echo "$temperature < $LOW_TEMP_THRESHOLD" | bc -l) -eq 1 && $(echo "$humidity < $LOW_HUMIDITY_THRESHOLD" | bc -l) -eq 1 ]]; then
    # 当温度和湿度都低于阈值时的特定消息
    broadcast_message="空气干燥且寒冷，请注意补水保湿和防寒保暖，${Org}祝您游戏愉快！"
elif [[ $(echo "$humidity < $LOW_HUMIDITY_THRESHOLD" | bc -l) -eq 1 ]]; then
    # 仅当湿度低于阈值时的特定消息
    broadcast_message="空气较为干燥，请注意补水保湿，${Org}祝您游戏愉快！"
elif [[ $(echo "$temperature < $LOW_TEMP_THRESHOLD" | bc -l) -eq 1 ]]; then
    # 当温度低于阈值时的特定消息
    broadcast_message="空气较为寒冷，请注意防寒保暖，${Org}祝您游戏愉快！"
else
    # 当温度和湿度均高于阈值时的常规消息
    broadcast_message="您的气候较为舒适，${Org}祝您游戏愉快！"
fi

# 发送天气播报
if [ $IfWeatherBroadcastCity == 1 ] ; then
	${WBHKHOME}/bin/rcon/rcon $SQUADCMD AdminBroadcast "欢迎${ServerVipNname} ${USER_NAME} 加入本服务器
您所在的${city}，当前温度为${temperature}℃，湿度为${humidity}%，天气$weather
$broadcast_message"
else
	${WBHKHOME}/bin/rcon/rcon $SQUADCMD AdminBroadcast "欢迎${ServerVipNname} ${USER_NAME} 加入本服务器
您所在的地区，当前温度为${temperature}℃，湿度为${humidity}%，天气$weather
$broadcast_message"
fi

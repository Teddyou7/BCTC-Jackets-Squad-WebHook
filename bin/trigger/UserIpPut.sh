#!/bin/bash
#UserIpPut.sh

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/trigger//g')/cfg/config.sh

if [ -z "$SquadGameLog" ]; then
    echo "SquadGameLog参数为空，脚本退出。"
    exit 1
fi

if [ $IfWeatherBroadcast -eq 0 ];then
	exit
fi

# 实时监控日志文件
tail -f "$SquadGameLog" | while read line; do
    if echo "$line" | grep -q "PostLogin: NewPlayer"; then
        # 提取IP和Steam ID
        ip=$(echo $line | awk -F'IP: ' '{print $2}' | awk '{print $1}')
        steam_id=$(echo $line | awk -F'steam: ' '{print $2}' | awk -F \) '{print $1}')

        # 调用其他程序或脚本
        # 例如: ./notify_program "$ip" "$steam_id"
        echo "$ip,$steam_id" >> ${WBHKHOME}/date/BasicData/NewLogin.log
        bash ${WBHKHOME}/bin/shell/AutomaticWeatherReporting.sh $ip $steam_id &
		bash ${WBHKHOME}/bin/shell/PlayersJoinTheBroadcast.sh $ip $steam_id &
        # 在这里插入您的通知或处理逻辑
        # ...
    fi
done

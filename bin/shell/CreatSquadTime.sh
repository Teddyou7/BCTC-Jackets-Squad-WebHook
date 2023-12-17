#!/bin/bash
#CreatSquadTime.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/CreatSquadTime
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.name}}%%{{player.steamID}}%%{{player.teamID}}%%{{msg.body}}%%1" 
# }
#}
#
#Version 1.1;2023/12/5 0:49;Teddyou；建队时间查询

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#player.teamID
player_teamID=`echo $1|awk -F '%%' '{print $3}'`
#msg.body
msg_body=`echo $1|awk -F '%%' '{print $4}'`

#ServerID
ServerID=`echo $1|awk -F '%%' '{print $5}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

TIME_FILE="${WBHKHOME}/date/tmp/CreatSquadInfo/CreatSquad.info"
TIME_FILE_TMP="${WBHKHOME}/date/tmp/CreatSquadInfo/CreatSquad.info.tmp"
TIME_FILE_SORT="${WBHKHOME}/date/tmp/CreatSquadInfo/CreatSquad.info.sort"

#删除多余的内容，保留固定行，加快处理速度
tail -n 300 $TIME_FILE > $TIME_FILE_TMP
mv $TIME_FILE_TMP $TIME_FILE

# 使用awk提取时间戳并添加到每一行，然后使用sort进行排序，最后输出排序结果
awk -F'%%' '{print $5, $0}' "$TIME_FILE" | \
  awk '{sub(/\.[0-9]+$/, "", $1); print $0}' | \
  sort -n -k1,1 | \
  awk '{print substr($0, length($1) + 1)}' > $TIME_FILE_SORT
  
# 将 UTC 时间字符串转换为时间戳
timestamp=$(date -d "$timestamp_tmp" +%s.%N)
# 将时间戳转换为北京时间字符串，只保留小数点后3位；获取小队创建时间
beijing_time=$(TZ='Asia/Shanghai' date -d "@$timestamp" +"%H:%M:%S.%N" | cut -c1-12)


# 处理参数
SquadTime() {
        beijing_time_tmp1=`grep "^ ${1}s${player_teamID}t" $TIME_FILE_SORT | tail -1 | awk -F '%%' '{print $5}'`
        beijing_time_tmp2=$(TZ='Asia/Shanghai' date -d "@${beijing_time_tmp1}" +"%H:%M:%S.%N" | cut -c1-12)
        echo $beijing_time_tmp2
}
SquadName() {
        grep "^ ${1}s${player_teamID}t" $TIME_FILE_SORT | tail -1 | awk -F '%%' '{print $4}'
}

#1?
SQUADS1=`echo $msg_body|awk '{print $2}'`
#2?
SQUADS2=`echo $msg_body|awk '{print $3}'`
#3?
SQUADS3=`echo $msg_body|awk '{print $4}'`
SQUAD=0
#检查传入参数
if [ -z $SQUADS1 ]; then
        echo "squad1 null"
        $CMDSH AdminBroadcast 建队时间查询失败，请使用格式：建队时间/SQUAD [小队ID-小队ID最大支持三个，空格隔开]
        exit
else
        if grep '^[[:digit:]]*$' <<< "$SQUADS1";then 
                SQUAD=1
        else 
                $CMDSH AdminBroadcast 建队时间查询失败，请使用格式：建队时间/SQUAD [小队ID-小队ID最大支持三个，空格隔开]
                exit
        fi 
fi

if [ -z $SQUADS2 ]; then
        echo "squad2 null"
else
        if grep '^[[:digit:]]*$' <<< "$SQUADS2";then 
                SQUAD=2
        else 
                echo "squad2 null"
        fi 
fi 

if [ -z $SQUADS3 ]; then
        echo "squad3 null"
else
        if grep '^[[:digit:]]*$' <<< "$SQUADS3";then 
                SQUAD=3
        else 
                echo "squad3 null"
        fi 
fi 

#传入参数 服务器ID%%阵营ID%%小队序号1%%序号2%%序号3，最多三位
if [ "$SQUAD" -eq 1 ];then
        PUT_T_1=`SquadTime $SQUADS1`
        PUT_N_1=`SquadName $SQUADS1`
        $CMDSH AdminBroadcast $player_name，已查询到您阵营的小队时间信息：[${SQUADS1}-${PUT_N_1}-${PUT_T_1}]
        
elif [ "$SQUAD" -eq 2 ];then
        PUT_T_1=`SquadTime $SQUADS1`
        PUT_N_1=`SquadName $SQUADS1`
        PUT_T_2=`SquadTime $SQUADS2`
        PUT_N_2=`SquadName $SQUADS2`
        $CMDSH AdminBroadcast $player_name，已查询到您阵营的小队时间信息：[${SQUADS1}-${PUT_N_1}-${PUT_T_1}]/[${SQUADS2}-${PUT_N_2}-${PUT_T_2}]
elif [ "$SQUAD" -eq 3 ];then
        PUT_T_1=`SquadTime $SQUADS1`
        PUT_N_1=`SquadName $SQUADS1`
        PUT_T_2=`SquadTime $SQUADS2`
        PUT_N_2=`SquadName $SQUADS2`
        PUT_T_3=`SquadTime $SQUADS3`
        PUT_N_3=`SquadName $SQUADS3`
        $CMDSH AdminBroadcast $player_name，已查询到您阵营的小队时间信息：[${SQUADS1}-${PUT_N_1}-${PUT_T_1}]/[${SQUADS2}-${PUT_N_2}-${PUT_T_2}]/[${SQUADS3}-${PUT_N_3}-${PUT_T_3}]
fi

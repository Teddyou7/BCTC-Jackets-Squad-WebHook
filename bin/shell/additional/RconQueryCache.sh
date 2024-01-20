#!/bin/bash
#RconQueryCache.sh
#请求内容：$1 服务器ID  $2命令  $3输出文件路径
#/usr/local/webhook/shell/tmp/RconQueryCache/test
#DATE=`date +'%H%M%S.%N'`     /usr/local/webhook/shell/tmp/RconQueryCache/RCON.$DATE

#用例
#	DATE=`date +"%s"`
#	FILE="${WBHKHOME}/date/tmp/RconQueryCache/CreatSquadBroadcast.$DATE"
#	${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID

ServerID=$3
CMD=$1
PUTFILE=$2

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

COUNTER1=0
#选中空闲的RCON
RCON_CMD(){
	while true
	do
		RCONCM=(`ps -ef|grep ${WBHKHOME}/bin/rcon|grep -v grep|awk '{print $8}'`)
		RCOMSF=`find ${WBHKHOME}/bin/rcon/ | grep [0-9]$ |shuf -n 1`
		if [ -z $RCONCM ]; then
			break
		fi 
		
		for I in ${!RCONCM[@]}
			do
			if [[ ${RCOMSF} != ${RCONCM[${I}]} ]];then
				break
			fi
		done
		sleep 1
		#最大循环次数，防止脚本进入死循环
		COUNTER1=$((COUNTER1+1))
		if [ $COUNTER1 -eq 100 ];then
			echo "RconQueryCache Failed!"
			break
		fi
	done
}

COUNTER2=0
while true
do
	RCON_CMD
	#执行命令开始生成缓存
	$RCOMSF $SQUADCMD $CMD > $PUTFILE
	
	ERR1=`cat $PUTFILE|wc -l`
	ERR2=`cat $PUTFILE | grep -E "Illegal size"\|Connection\|Authenticate |grep -vE command\|Message\|broadcasted |wc -l`
	if [ $ERR1 -gt 2 ] || [ $ERR2 -eq 0 ] ;then
		break 
	else
		sleep 1
	fi
	
	#最大循环次数，防止脚本进入死循环
	COUNTER2=$((COUNTER2+1))
	if [ $COUNTER2 -eq 1000 ];then
		echo "RCON Failed!"
		break
	fi
done

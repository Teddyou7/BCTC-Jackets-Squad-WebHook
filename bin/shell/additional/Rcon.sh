#!/bin/bash
#解决黄字报错的问题，注意，此脚本只能解决AdminBroadcast来带的报错，用于其他方面会导致单行输出。
#
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

COUNTER1=0
#选中空闲的RCON
RCON_CMD(){
	while true
	do
		RCONCM=(`ps -ef|grep ${WBHKHOME}/bin/rcon|grep -v grep|awk '{print $8}'`)
		RCOMSF=`find ${WBHKHOME}/bin/rcon/ |grep [0-9]$ |shuf -n 1`
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
		if [ $COUNTER1 -eq 50 ];then
			echo "RCON_CDM Failed!"
			break
		fi
	done
}

COUNTER=0
while true
do
	RCON_CMD
	DATE=`date +'%H%M%S.%N'`
	$RCOMSF $1 $2 $3 $4 $5 $6 $7 $8 $9 > ${WBHKHOME}/logs/RconLog/$DATE
	Return=`cat ${WBHKHOME}/logs/RconLog/$DATE`
	ERR=`echo $Return |grep -E "Illegal size"\|Connection\|Authenticate |grep -vE command\|Message\|broadcasted |wc -l`
	if [ $ERR -eq 0 ];then
		echo "COUNTER=$COUNTER"
		echo $Return
		break
	fi
	#最大循环次数，防止脚本进入死循环
	COUNTER=$((COUNTER+1))
	if [ $COUNTER -eq 100 ];then
		echo $Return
		echo "Execution failed!"
		break
	fi
sleep 1
done

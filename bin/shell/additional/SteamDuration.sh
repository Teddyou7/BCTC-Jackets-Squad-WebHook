#!/bin/bash
#SteamDuration.sh
#steam时长查询接口：
#CGI对外的API开放能力，以保护查询密钥安全性。
#传入参数 1steamid
#返回参数 steam时长，为空则返回null
#返回时长为分钟数
steamid=$1

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

if [ $SteamApiMODE -eq 1 ];then
	curl http://api.bctc-squad.cn:8088/api/SteamDuration.sh?${steamid}
	exit
fi

ls ${WBHKHOME}/date/tmp/SteamDuration/${steamid} &> /dev/null
if [ $? -ne 0 ];then
	curl -s "http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v1/?key=${SteamApiKey}&steamid=${steamid}" > ${WBHKHOME}/date/tmp/SteamDuration/${steamid}
fi
#是否公开资料
QNU=`cat ${WBHKHOME}/date/tmp/SteamDuration/${steamid} |grep Squad |wc -l`
if [ $QNU -eq 1 ];then
  NAME=(`cat ${WBHKHOME}/date/tmp/SteamDuration/${steamid} |/usr/bin/jq '.response.games'| python3 -c "import sys, json; data=json.load(sys.stdin); print([d['appid'] for d in data])" | sed 's/\[\|\]\|\,//g'`)
  STMM=(`cat ${WBHKHOME}/date/tmp/SteamDuration/${steamid} |/usr/bin/jq '.response.games'| python3 -c "import sys, json; data=json.load(sys.stdin); print([d['playtime_forever'] for d in data])" | sed 's/\[\|\]\|\,//g'`)
fi

COUNTER=0
NAMESUM=`echo ${#NAME[@]}`
while true
do
  if [ $QNU -eq 0 ];then
    break
  fi
  if [ $NAMESUM -eq 0 ];then
   break
  fi
  NAMES=`echo ${NAME[$COUNTER]} | grep -w 393380 | wc -l`
  if [ $NAMES -eq 1 ];then
    STMM1=${STMM[$COUNTER]}
	break
  fi
  COUNTER=$((COUNTER+1))
  if [ $COUNTER -eq $NAMESUM ];then
   break
  fi
 #sleep 3
done

#判定是否空,清理缓存，返回null
if [ $QNU -eq 0 ];then
	echo null
	rm -f ${WBHKHOME}/date/tmp/SteamDuration/${steamid}
	exit
fi

#有结果则返回分钟数
echo $STMM1
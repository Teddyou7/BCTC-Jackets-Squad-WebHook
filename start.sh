#!/bin/bash
###
#cfg_update
DIR=$(echo $(cd `dirname $0`; pwd))
SEDN=`cat ${DIR}/cfg/config.sh -n |grep WBHKHOME= |awk '{print $1}'|head -1`
DIR_tmp=${DIR//\//\\\/}
sed -i ''"${SEDN}"'s/.*/WBHKHOME='"${DIR_tmp}"'/' ${DIR}/cfg/config.sh
source $(echo $(cd `dirname $0`; pwd))/cfg/config.sh
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/cfg/webhook.json

#赋予执行权限
chmod +x -R ${WBHKHOME}/bin/shell/*
chmod +x -R ${WBHKHOME}/bin/rcon/*
chmod +x ${WBHKHOME}/start.sh
chmod +x ${WBHKHOME}/webhook
chmod +x ${WBHKHOME}/cfg/*

#创建路径
mkdir -p ${WBHKHOME}/logs/RconLog
mkdir -p ${WBHKHOME}/logs/user
mkdir -p ${WBHKHOME}/logs/webhook
mkdir -p ${WBHKHOME}/date/sign
mkdir -p ${WBHKHOME}/date/tmp/AverageGameDuration
mkdir -p ${WBHKHOME}/date/tmp/RconQueryCache
mkdir -p ${WBHKHOME}/date/tmp/SteamDuration
mkdir -p ${WBHKHOME}/date/txt
mkdir -p ${WBHKHOME}/date/user

#验证SteamAPI是否可用。
steamid='76561198000000000'
if [ $SteamApiMODE -eq 0 ];then
	echo "正在验证SteamAPI可用性。"
	curl -s "http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v1/?key=${SteamApiKey}&steamid=${steamid}" > ${WBHKHOME}/date/tmp/SteamDuration/${steamid}
	TMP_SteamAPIAccess=`cat ${WBHKHOME}/date/tmp/SteamDuration/${steamid} | grep "Access is denied." | wc -l`
	if [ $TMP_SteamAPIAccess -eq 1 ];then
		echo "启动失败，SteamAPI不可使用，请修改"
		exit
	fi
	echo "SteamAPI可用。"
fi

#主程序启动
cd ${WBHKHOME}
kill -9 `ps -ef|grep ${WBHKHOME}/webhook |grep -v grep|awk '{print $2}'` &> /dev/null 
mv ${WBHKHOME}/log ${WBHKHOME}/logs/webhook/`date +"%Y%m%d%H%M%S"`.log
nohup ${WBHKHOME}/webhook -port ${WebHookPort} -hotreload -hooks ${WBHKHOME}/cfg/webhook.json -verbose >> ${WBHKHOME}/log &

#其他启动项目
kill -9 `ps -ef|grep ${WBHKHOME}/bin/shell/additional/TimedSchedule.sh |grep -v grep|awk '{print $2}'` &> /dev/null 
nohup ${WBHKHOME}/bin/shell/additional/TimedSchedule.sh &> /dev/null &

echo "BCTC-Jackets Restart!"
echo "Support： support@bctc-squad.cn or QQgroup:703511605"
echo "WebHook startup completed!"
echo "Version 0.1.122-2023/10/31 20:20"
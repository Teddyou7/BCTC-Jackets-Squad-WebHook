#!/bin/bash
echo "BCTC-Jackets Restart!"

#cfg_update
DIR=$(echo $(cd `dirname $0`; pwd))
SEDN=`cat ${DIR}/cfg/config.sh -n |grep WBHKHOME= |awk '{print $1}'|head -1`
DIR_tmp=${DIR//\//\\\/}
sed -i ''"${SEDN}"'s/.*/WBHKHOME='"${DIR_tmp}"'/' ${DIR}/cfg/config.sh
source $(echo $(cd `dirname $0`; pwd))/cfg/config.sh
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/cfg/webhook.json
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/cfg/RemoteAdmins.json

#赋予执行权限
chmod +x -R ${WBHKHOME}/bin/
chmod +x ${WBHKHOME}/start.sh
chmod +x ${WBHKHOME}/webhook
chmod +x ${WBHKHOME}/cfg/

#创建路径
mkdir -p ${WBHKHOME}/logs/RconLog
mkdir -p ${WBHKHOME}/logs/user
mkdir -p ${WBHKHOME}/logs/webhook
mkdir -p ${WBHKHOME}/date/SignIn
mkdir -p ${WBHKHOME}/date/tmp/AverageGameDuration
mkdir -p ${WBHKHOME}/date/tmp/RconQueryCache
mkdir -p ${WBHKHOME}/date/tmp/SteamDuration
mkdir -p ${WBHKHOME}/date/tmp/CreatSquadInfo
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
kill -9 `ps -ef|grep ${WBHKHOME} |grep -v grep|awk '{print $2}'` > /dev/null 2>&1 
mv ${WBHKHOME}/log ${WBHKHOME}/logs/webhook/`date +"%Y%m%d%H%M%S"`.log
nohup ${WBHKHOME}/webhook -port ${WebHookPort} -hotreload -hooks ${WBHKHOME}/cfg/webhook.json -verbose >> ${WBHKHOME}/log 2>&1 &
echo "WebHook startup completed!"

#其他启动项目
nohup ${WBHKHOME}/bin/shell/additional/TimedSchedule.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/shell/additional/DelAdmins.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/shell/additional/PermissionVerification.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/shell/additional/DuplicateCheck.sh > /dev/null 2>&1 &
echo "Additional startup completed!"

#RemoteAdminList远程权限系统启动，此处默认不启动。
#服务器安装其他http服务可将py程序的启动注释，使用ln -s链接指向$RemoteAdminList文件即可！
#nohup python3 ${WBHKHOME}/bin/python/http_file_server.py ${WBHKHOME}/cfg/RemoteAdmins.json >> ${WBHKHOME}/logs/webhook/http_file_server.log 2>&1 &
#echo "RemoteAdmins startup completed!"
#echo "RemoteAdminsURL: http://127.0.0.1:27088/AdminInfo"

# 初始化进度条
echo -n "Loading "
# 设定进度条长度
progress_length=20
for ((i=0; i<$progress_length; i++)); do
    echo -n '#'
    sleep 0.1  
done
echo " Done!"

echo "------------------------------------------"
echo "Version 0.1.139-2023/12/15 22:59"
echo "Welcome to the BCTC-Jackets system!"
echo "Web: https://bctc-squad.cn"
echo "Discord: https://discord.gg/DAnEG7gkpt"
echo "QQgroup: 703511605"
echo "SupportMail： support@bctc-squad.cn"
echo "------------------------------------------"

#交互程序，作用不大
#bash ${WBHKHOME}/bin/shell/additional/InteractiveManager.sh
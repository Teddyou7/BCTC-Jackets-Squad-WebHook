#WebHook启动端口
WebHookPort='9330'

#设置Web登录用户
NginxLoginUser="Admin"
#设置Web登录密码
NginxLoginPass="Admin@123"

#PHP-FPM监听端口 - 根据本地安装php-fpm实际情况设置
PHPFPMPort=9740

#Nginx启动端口
NginxStartPort=38088

#游戏日志路径
SquadGameLog="/SquadGame/Saved/Logs/SquadGame.log"

#设置steam资料请求方式，由冲锋号社区代理APIKey=1，本地请求=0，设置为0请确保您的密钥正确，否则将无法正常拉取数据。
#冲锋号社区代理目前免费使用。  http://api.bctc-squad.cn:8088/api/SteamDuration.sh?
SteamApiMODE=1
#Steam时长本地获取规则缓存时间（分钟）
SteamDurationTmpMin=60

#权限等级列表文件 写入64ID即可
Admins_User_S="${WBHKHOME}/date/BasicData/Admins_S"
Admins_User_A="${WBHKHOME}/date/BasicData/Admins_A"
Admins_User_B="${WBHKHOME}/date/BasicData/Admins_B"
Admins_User_C="${WBHKHOME}/date/BasicData/Admins_C"

#玩家快照所需要的权限等级 PlayerListSnapshots
PlayerListSnapshots_AdminsList=$Admins_User_A

#随机打乱所需要的权限等级
ConfirmRandomShuffling_AdminsList=$Admins_User_S

########## 其他 ##########

#远程RemoteAdminsURL默认为http://127.0.0.1:27088/AdminInfo
#修改此处路径需要同步修改${WBHKHOME}/cfg/http_file_server.json文件！
RemoteAdminList="${WBHKHOME}/date/user/Admins.cfg"

#预留位计时系统用户信息存放路径
ReservedUserInfo="${WBHKHOME}/date/user/ReservedUserInfo.ini"
#签到特权计时系统用户信息存放路径
SignVIPUserInfo="${WBHKHOME}/date/user/SignVIPUserInfo.ini"
#积分系统用户信息存放路径
PointsUserInfo="${WBHKHOME}/date/user/PointsUserInfo.ini"

#${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $steamid
#${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE_TMP $ServerID
#${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh 
#${WBHKHOME}/bin/shell/additional/QueryAllSteamUserInformation.sh SteamID timecreated

#用户信息变动记录路径
UserOperateLog="${WBHKHOME}/logs/user/"

#预留位CDK激活码存放路径
#注意CDK格式，BCTC-RESERVE-2592000-XXXXXX-XXXXXX-XXXXXXX
#以-分割，第一位为定制化内容，可以是你的组织简写，第三位为激活的时间戳，后方是随机的加密字符。
File_ReservedCDKFilePath="${WBHKHOME}/date/cdkey/ReservedCDK"

#积分CDK存放路径
##注意CDK格式，BCTC-POINTS-2000-XXXXXX-XXXXXX-XXXXXXX
#以-分割，第一位为定制化内容，可以是你的组织简写，第三位为激活的积分数额，后方是随机的加密字符。
File_PointsCDKFilePath="${WBHKHOME}/date/cdkey/PointsCDK"

#签到特权CDK激活码存放路径
#注意CDK格式，BCTC-SIGNVIP-2592000-XXXXXX-XXXXXX-XXXXXXX
#以-分割，第一位为定制化内容，可以是你的组织简写，第三位为激活的时间戳，后方是随机的加密字符。
File_SignVIPCDKFilePath="${WBHKHOME}/date/cdkey/SignVIPCDK"

UserSignLogFile="${WBHKHOME}/date/SignIn/"

#单一实例配置
CMDSH="${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p${RconPort}"
SQUADCMD=" -a${ServerIP} -P${RconPasswd} -p${RconPort}"
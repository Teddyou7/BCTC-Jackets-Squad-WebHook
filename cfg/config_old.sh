#注意，此项目中附带了一个已经编译好的WebHook程序，如果您对此程序不放心，可自行编译替换，项目地址：https://github.com/adnanh/webhook
#其使用的RCON程序也是编译好的，如果不放心可审核源码后自行编译，源码为：https://github.com/Teddyou7/BCTC-Jackets-Squad-WebHook/blob/main/bin/rcon/rcon.c
#其使用的MCRCON源码为：https://github.com/Tiiffi/mcrcon
#
#正确使用此包需要配置BattleMetrics的触发器！由触发器决定脚本调用，功能脚本注释中将会提示传参格式，或使用后续建设的文档
#
#冲锋号社区 - 战术小队 - 冲锋衣插件辅助系统
#Come from: -冲锋号-Teddyou
#参数设置

#WebHook根目录位置(无需修改，启动脚本会自动识别)
WBHKHOME="/home/squad/webhook"

#服务器IP
ServerIP="127.0.0.1"

#服务器RCON端口号
RconPort="21114"

#服务器RCON端口密码
RconPasswd="XXXXXX"

#WebHook启动端口
WebHookPort='9330'

#游戏日志路径
SquadGameLog="/SquadGame/Saved/Logs/SquadGame.log"

#组织标识
Org="冲锋号社区"

#游戏时长数据是否输出完整数据，如果需要，请补充完整的 BattleMetricsAPI token 信息
#https://www.battlemetrics.com/developers
BMAPITOKEN="BMAPITOKEN is null!"

#设置此API可从本机请求steam玩家资料，从本地获取资料请确保您的系统支持Python3[3.6.8]和jq[version 1.6]。
#https://steamcommunity.com/dev/apikey
SteamApiKey="null"

#百度API-如能获取到游戏日志，则可通过此功能开启气象播报能力
#https://lbsyun.baidu.com/apiconsole/quota#/home
BAIDUAPIAK=""

#设置steam资料请求方式，由冲锋号社区代理APIKey=1，本地请求=0，设置为0请确保您的密钥正确，否则将无法正常拉取数据。
#冲锋号社区代理目前免费使用。  http://api.bctc-squad.cn:8088/api/SteamDuration.sh?
SteamApiMODE=1
#BCTC_SteamApiKey="null"
#Steam时长本地获取规则缓存时间（分钟）
SteamDurationTmpMin=60

#积分名称
PointsName="积分"

#是否开启牛子长度娱乐功能 不开启=0
NiuZiChangDuIf=1
#牛子长度留存分钟数
NiuZiChangDuTimeTmp=432

#自动更新的请求目标主机以及token
UPDATEKEY="teddyou"
HOSTIPPORT="42.193.48.240:23450"

#是否开启IP定位气象播报 0=不开启
IfWeatherBroadcast=1
#定位广播是否精确到地市 1=是
IfWeatherBroadcastCity=1
#VIP名称
ServerVipNname="VIP"
#气象广播时候的服务器名称
WeatherBroadcastServerNname="本服务器"

#玩家小喇叭消耗积分
PlayerServerSpeakerPoints=10
#玩家大喇叭消耗积分
PlayerGroupSpeakerPoints=30
#是否上传大喇叭联动 1=是 0=否
PlayerGroupSpeakerIf=1

#小队创建广播模式，此功能关联小队创建时间查询
# 0=不广播 1=全部广播 2=不符合指定时长广播
CreatSquad_BroadcastMODE=2
#小队创建广播模式3 指定时长（分钟）
SLSteamDuration=6000

#积分兑换预留位最低数值
PointsActivationReservedLow=20
#用户积分兑换预留位比例 1分兑换多少秒预留位？(默认3600 一小时)
#此参数也控制了发福利和抢红包功能的兑换比例
PointsToReserved=3600
#用户签到模式 0=关闭此功能 1=任何人可签到 2=已有预留位用户可签到
#如果为模式2，预留位可签到将直接增加预留位时长，签到特权功能将会失效，必须配置VIPSignRecharge
SignMod=1
#预留位签到加时秒数
VIPSignRecharge=43200
#签到用户在线时间限制（秒）
SignSessionDurationMin=1200

#权限等级列表文件 写入64ID即可
Admins_User_S="${WBHKHOME}/date/BasicData/Admins_S"
Admins_User_A="${WBHKHOME}/date/BasicData/Admins_A"
Admins_User_B="${WBHKHOME}/date/BasicData/Admins_B"
Admins_User_C="${WBHKHOME}/date/BasicData/Admins_C"
#玩家快照所需要的权限等级 PlayerListSnapshots
PlayerListSnapshots_AdminsList=$Admins_User_A
#发福利功能最低发放限制(单位：积分)
GrantReservedWelfareLow=12

#随机打乱所需要的权限等级
ConfirmRandomShuffling_AdminsList=$Admins_User_S

#发红包功能
#是否开启发红包的功能 0=不开启 1=开启
HandOutRedEnvelopesStart=1
#发红包红包的最低单个红包使用积分
HandOutRedEnvelopesLow=12
#抢得红包处理方式 1=直充预留位 2=直充积分
SnatchingRedEnvelopesMod=1
#红包过期时间，分钟
RedEnvelopesBecomeDue=4320
#每次抢红包间隔时间，分钟
RedEnvelopesCooldown=20

#是否开启比赛模式用户准入许可（不可用，相关关键程序仅在SOI定制版发布）
#CompetitionAdmission=0
#如果开启，你需要修改CompetitionAdmissionFile文件，输入SteamID，每行一个，文件不存在则新建文件夹，请注意需要使用Unix文档格式
#CompetitionAdmissionFile="${WBHKHOME}/date/user/AdmissionUserSteamID"

#功能包括：开局跳过等待准备时间、放开所有限制、跳过结算界面
#是否开启冲锋号社区直升机公开训练服模式-开局跳过并解除所有限制 0=关
BCTC_TrainingMatchIf=0
#是否开启冲锋号社区直升机公开训练服模式-击杀检测及炮手位检查自动踢出 0=关
BCTC_TrainingActualDamageIf=0
#是否开启冲锋号社区直升机公开训练服模式-炮手位检查自动踢出 0=关
BCTC_TrainingTurretIf=0
#是否开启冲锋号社区直升机公开训练服模式-玩家身份自助切换地图 0=关
BCTC_TrainingChangeLayer=0
#是否开启冲锋号社区直升机公开训练服模式-玩家身份自助切换地图冷却时间（每个玩家冷却分钟）
BCTC_TrainingChangeLayerCDTime=60

#是否开启冲锋号社区直升机公开训练服模式-结束时时间倍数控制 0=关 此功能在认证服务器不要开启！
BCTC_LogSquadGameEventsIf=0 
#对局结束时刻的时间倍数，可调整为 0-20 ,注意，如果调整为 0 ，那么时间将会暂停！ 直到管理员重新刷入新的 AdminSlomo
EndMatchTimeMultiplier=1


###### 下方内容请勿修改 ######

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

#调用输入ServerID=serverID，定义变量CMDSH，一次性管理多实例配置；设置此多实例可无视上方配置的登录信息进行设置。
#$ServerID是服务器编号，一般以#1 #2 #3等区分，需要修改脚本自行处理此参数。
#注意！尚未针对多实例进行调试，设置后可能会存在错误！如有问题请及时联系！
#if [ "$ServerID" -eq 1 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p21114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p21114'
#elif [ "$ServerID" -eq 2 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p22114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p22114'
#elif [ "$ServerID" -eq 3 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p23114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p23114'
#elif [ "$ServerID" -eq 4 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a127.0.0.1 -P${RconPasswd} -p24114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p24114'
#elif [ "$ServerID" -eq 5 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a127.0.0.1 -P${RconPasswd} -p25114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p25114'
#elif [ "$ServerID" -eq 6 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a127.0.0.1 -P${RconPasswd} -p26114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p26114'
#fi

#单一实例配置
CMDSH="${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p${RconPort}"
SQUADCMD=" -a${ServerIP} -P${RconPasswd} -p${RconPort}"
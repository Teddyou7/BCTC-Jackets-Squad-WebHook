#服务器IP
ServerIP="127.0.0.1"

#服务器RCON端口号
RconPort="21114"

#服务器RCON端口密码
RconPasswd="XXXXXX"

#组织标识
Org="冲锋号社区"

#积分名称
PointsName="积分"
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
#发福利功能最低发放限制(单位：积分)
GrantReservedWelfareLow=12

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

#玩家小喇叭消耗积分
PlayerServerSpeakerPoints=30
#玩家大喇叭消耗积分
PlayerGroupSpeakerPoints=100
#是否上传大喇叭联动 1=是 0=否
PlayerGroupSpeakerIf=0

#是否开启牛子长度娱乐功能 不开启=0
NiuZiChangDuIf=1
#牛子长度留存分钟数
NiuZiChangDuTimeTmp=432

#是否开启IP定位气象播报 0=不开启
IfWeatherBroadcast=1
#定位广播是否精确到地市 1=是
IfWeatherBroadcastCity=1
#VIP名称
ServerVipNname="VIP"
#气象广播时候的服务器名称
WeatherBroadcastServerNname="本服务器"

#小队创建广播模式，此功能关联小队创建时间查询
# 0=不广播 1=全部广播 2=不符合指定时长广播
CreatSquad_BroadcastMODE=2
#小队创建广播模式3 指定时长（分钟）
SLSteamDuration=6000

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

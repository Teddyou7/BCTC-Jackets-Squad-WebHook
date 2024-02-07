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
#是否开启积分兑换预留位功能 0=关
PointsActivationReservedIf=1
#签到积分是否为定额积分，非定额留空，定额填写定额数字
SignInPOINTS=''
#是否限制签到玩家数，比如大于这个数值(非暖服的状态)就不可以签到了
SignInMaxPlayers=""
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

#是否开启玩家喇叭喊话功能 0=关
PlayerSpeakerSwitch=1
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
#牛子长度每次收费，支持小数
NiuZiChangDuPoints=0
#换牛子每次收费，支持小数
NewNiuZiChangDuPoints=5

#是否开启IP定位气象播报 0=不开启
IfWeatherBroadcast=1
#定位广播是否精确到地市 1=是
IfWeatherBroadcastCity=1
#VIP名称
ServerVipNname="VIP"
#气象广播时候的服务器名称
WeatherBroadcastServerNname="本服务器"

#天气主动查询功能开关 0=关
RealTimeWeather=1
#是否隐藏省市位置 1=是
RealTimeWeatherCity=1
#单次查询积分消耗，支持小数
RealTimeWeatherPoints=2

#小队创建广播模式，此功能关联小队创建时间查询
# 0=不广播 1=全部广播 2=不符合指定时长广播
CreatSquad_BroadcastMODE=2
#小队创建广播模式3 指定时长（分钟）
SLSteamDuration=12000

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

#是否开启KD查询 0=关
UserKDinfo=1
#KD查询每次消耗积分数额 ，支持小数
UserKDinfoPoints="2.66"
#KD查询口令（不能包含空格）
UserKDinfoToken="kd"

#是否开启高级战斗信息 0=关
#高级战斗信息会实时提示开启人的战斗数据，以警告的形式，反馈伤害数值、击倒、被谁击倒或命中。 0=关
AdvancedCombatInformation=1
#高级战斗信息每次激活积分
AdvancedCombatInformationPoints=58
#高级战斗信息单次激活后授权的秒数，时间未道不能加时，建议不超过一天；单位为秒。
AdvancedCombatInformationTime=86400
#高级战斗信息激活口令（不能包含空格）
AdvancedCombatInformationToken="激活高级战斗信息"

#是否开启票差打乱，本功能打开状态会导致“确认结束打乱”功能失效 0=关
TicketsGapConfirmRandomShufflingIf=0
#票数差距大小
TicketsGapNumber=200
#票差打乱是否屏蔽侵攻模式 0=否,1=是
TicketsGapInvasionShufflingIf=1

#随机选择管理员功能开关 0=关 (需要配置Admins_User_B)
RandomlySelectAdministratorsSwitch=1

#是否检查飞天后落地参战 0=关
AdminCamCheck=1
#检查完成后处理方式 1=踢出服务器，且邮件通知  2=ban出服务器（1天），且邮件通知  3=仅邮件通知（附件添加相关日志）
AdminCamCheckProcessingMethod=3
#通知邮箱地址（仅支持配置一个,但是可以配置邮箱组进行自动转发）
AdminCamNoticeMail="support@bctc-squad.cn"

#每小时抽奖功能，抽奖模式 0=关 1=仅能够抽中预留位 2=仅能够抽中积分 3=积分与预留位随机中奖一个 4=积分与预留位均能中奖
HourlyLotterySwitch=3
#服务器最低玩家数 当服务器内玩家数低于这个数值的时候任何人不可抽奖
HourlyLotteryPlayersMin=10
#抽奖原理：
#用户在抽奖的时候，会根据HourlyLotteryDifficulty设置的参数，随机获取一个零至$HourlyLotteryDifficulty的随机数，比如按照默认的，那么就是0-5000的随机数。
#然后根据当前服务器的在线人数，去确定难度，比如我获取了一个随机数，然后拿到了30这个数字，但是当前服务器在线有50人，那么我的随机数变成了30+$Difficulty40=45（根据默认的Difficulty40=15）
#然后，根据我的随机数，查看WinningLevel奖励，45，应该倒序匹配，先匹配是否小于WinningLevelReserved1(3)，然后不是，再匹配是小于WinningLevelReserved2（30），匹配失败，继续匹配是否小于WinningLevelReserved3，发现匹配命中，那么这可能是我的奖品之一，因为我还要匹配积分奖励，略过上面的步骤，匹配到WinningLevelPoints3这一层，那么我就应该获得 7天预留位 与 188积分 的奖励，但是，这个时候，我们再看下HourlyLotterySwitch的模式，当前的模式是3，也就是说 积分与预留位随机中奖一个 ，也就是说这个奖励里面，我还要再随机一次，随机选择其中的一个，但如果是模式1，那么就只能是 7天预留位 ，如果是模式4，那么就是两个都获得，模式2是仅能获得积分。
#抽奖用户在线时间限制（秒）
HourlyLotterySessionDurationMin=600
#抽奖难度 数值越高越难中奖
HourlyLotteryDifficulty=8000
#服务器在线人数档位抽奖难度配置
#0-20人难度
Difficulty20=0
#20-40人难度
Difficulty40=15
#40-60人难度
Difficulty60=28
#60-80人难度
Difficulty80=77
#80-100人难度
Difficulty100=120
#奖项难度设置（5个等级）
#30天预留位
WinningLevelReserved1=5
#14天预留位
WinningLevelReserved2=40
#7天预留位
WinningLevelReserved3=140
#3天预留位
WinningLevelReserved4=200
#1天预留位
WinningLevelReserved5=850
#888积分
WinningLevelPoints1=3
#388积分
WinningLevelPoints2=30
#188积分
WinningLevelPoints3=150
#88积分
WinningLevelPoints4=300
#20积分
WinningLevelPoints5=550
#安慰奖难度
WinningLevelComfort=5000
#安慰奖积分数额 （可使用小数，但小数点最多两位数） 
HourlyLotteryComfort="0.38"

#抽奖未中奖文案调用方式 0=本地 1=网络API文案（https://tenapi.cn/v2/yiyan）
HourlyLotteryCopywriting=1

#是否使用防沉迷系统 0=关 （此功能触发需要玩家主动发送消息，通过BM传入参数判断在线时长）
PreventAddiction=1
#防沉迷触发底线 持续在线大于多少秒
PreventAddictionOnline=10800
#防沉迷提醒冷却间隔(分钟)
PreventAddictionCD=5

#是否开启每日运势查询 0=关
DailyFortuneSwitch=1
#单次查询费用（积分，支持小数）
DailyFortunePoints=0
#额外奖励积分的气运
DailyFortuneFate="财运"
#额外奖励积分冷却时间（分钟）
DailyFortuneFateCD=720
#额外奖励积分数额
DailyFortuneFatePoints="8.88"

#是否开启每日头条 0=关
HotSearchSwitch=1
#单次查询费用（积分，支持小数）
HotSearchPoints=0

#历史地图开关 0=关
HistoricalMapSwitch=1
#历史地图显示地图数量
HistoricalMapNumber=5

#积分跳边开关 0=关
ChangeCampSwitch=1
#积分跳边触发词汇（默认通用强制词汇为 !tb ）
ChangeCampName='积分跳边'
#积分跳边费用，支持小数（小数使用引号）
ChangeCampPoints="8.88"
#积分跳边冷却时间(分钟)
ChangeCampCD=10



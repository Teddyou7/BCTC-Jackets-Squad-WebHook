
欢迎使用此项目，此项目由冲锋号社区发起，我将其命名为冲锋衣项目，是以服务器辅助和娱乐为主的插件，当前正在对原有功能的重构，进行开发；冲锋号社区门户群：703511605


在启动之前请前往 ./cfg/config.sh 修改配置文件，配置您的服务器IP、端口、Rcon密码、社区标识等信息。

首次启动请使用命令 bash ./start.sh 启动


注意！本项目随时更新，请及时更新！包括./cfg/config.sh文件，也可能存在新增配置项目，但是在更新过程中，会放入一些开发到一半的内容，但是以下列出的可配置项目是开发调测完成的内容。


注意！本项目所使用的内容均需要通过BattleMetrics实现，可根据下方提示灵活配置，下方多数内容只是建议值。


一、对局平均时长查询

BattleMetrics - Trigger

-Trigger Type

--Player Message

-Conditions

--[OR] When any of the conditions are met.

---Message - Contains (Case-insensitive) - avg

---Message - Contains (Case-insensitive) - 平均时长

-Actions

--Webhook[Add Action]

-Webhook

--URL

http://127.0.0.1:9300/hooks/AverageGameDuration

--Body

{

  "msgtype": "val",
  
  "text":{
  
  "content":"{{player.name}}%%{{player.steamID}}%%1" 
  
 }
 
}


二、查询小队员功能

BattleMetrics - Trigger

-Trigger Type

--Player Message

-Conditions

--[AND] When all conditions are met.

---Is Squad Leader - Equal (=) - True

---[OR] When any of the conditions are met.

----Message - Contains (Case-insensitive) - 查询小队员

----Message - Contains (Case-insensitive) - cxxdy

-Actions

--Webhook[Add Action]

-Webhook

--URL

http://127.0.0.1:9300/hooks/TeamDuration

--Body
{
  "msgtype": "val",
  "text":{
  "content":"{{player.name}}%%{{player.steamID}}%%1" 
 }
}

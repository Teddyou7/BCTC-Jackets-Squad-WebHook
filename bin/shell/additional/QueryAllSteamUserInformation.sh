#!/bin/bash
# QueryAllSteamUserInformation.sh SteamID DataType
# 取消 BM API 转向使用 Steam API 获取更准确的 Steam 用户信息

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

# 检查是否传递了 Steam ID
if [ -z "$1" ]; then
    echo "请提供 Steam ID"
    exit 1
fi

# 设置变量
STEAMID=$1
DATA_TYPE=$2
STEAM_API_KEY=$SteamApiKey
API_URL_PLAYER_SUMMARIES="http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/"
API_URL_OWNED_GAMES="http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/"

# 发送请求并获取玩家摘要信息
RESPONSE_SUMMARIES=$(curl -s "$API_URL_PLAYER_SUMMARIES?key=$STEAM_API_KEY&steamids=$STEAMID&format=json")

# 发送请求并获取拥有的游戏信息
RESPONSE_OWNED_GAMES=$(curl -s "$API_URL_OWNED_GAMES?key=$STEAM_API_KEY&steamid=$STEAMID&format=json&include_appinfo=true&include_played_free_games=true")

# 提取数据
extract_data() {
    echo $RESPONSE_SUMMARIES | jq -r ".response.players[0].$1"
}

# 根据传入的 $2 参数决定输出
case $DATA_TYPE in
    "timecreated")
        # 提取账户创建时间
        extract_data "timecreated"
        ;;
    "gamecount")
        # 提取拥有的游戏数量
        echo $RESPONSE_OWNED_GAMES | jq -r ".response.game_count"
        ;;
    "playtime")
        # 提取所有游戏的游玩时间总和（单位：分钟）
        echo $RESPONSE_OWNED_GAMES | jq -r "[.response.games[].playtime_forever] | add"
        ;;
    *)
        # 默认输出全部信息
        echo $RESPONSE_SUMMARIES | jq
        echo $RESPONSE_OWNED_GAMES | jq
        ;;
esac

#!/bin/bash
#PlayerGameID.sh
#查询玩家对局ID，如果不存在，则生成缓存
#传参 $1 steamid 返回ID数值

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

steamid=$1
FILE_TMP=${WBHKHOME}/date/tmp/PlayerGameID/PlayerGameID.tmp
LIST_FILE=${WBHKHOME}/date/tmp/PlayerGameID/PlayerGameID.list

# 尝试查询特定次数
attempt=0
max_attempts=5

# 首先尝试在 LIST_FILE 中查找玩家ID
if grep -q "$steamid" "$LIST_FILE"; then
    grep "$steamid" "$LIST_FILE" | awk '{print $2}'
else
    while [ $attempt -lt $max_attempts ]; do
        if grep -q "$steamid" "$FILE_TMP"; then
            grep "$steamid" "$FILE_TMP" | awk '{print $2}' 
            # 更新 LIST_FILE
            cp "$FILE_TMP" "$LIST_FILE"
            break
        else
            if [ $attempt -eq 0 ]; then
                # 第一次尝试时生成缓存
                ${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE_TMP $ServerID
            fi
            sleep 1  # 等待缓存生成
            attempt=$((attempt + 1))
        fi
    done

    if [ $attempt -eq $max_attempts ]; then
        echo "null"
    fi
fi

#!/bin/bash
#DuplicateCheck.sh
# 用户列表查重脚本，保留最高的值，删除最低的。

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

DuplicateInfoUpdate() {
    local file=$1
    local steamid
    local max_value
    local current_value

    # 检查是否存在重复的 Steam ID
    local unique_ids=$(awk -F ':' '{print $1}' "$file" | sort | uniq -c | awk '$1 > 1 {print $2}')
    if [[ -z "$unique_ids" ]]; then
        #echo "No duplicates found in $file."
        return
    fi

    # 处理每个重复的 Steam ID
    for steamid in $unique_ids; do
        max_value=0
        while read -r line; do
            if [[ "$line" == "$steamid:"* ]]; then
                current_value=$(echo "$line" | awk -F ':' '{print $2}')
                if (( current_value > max_value )); then
                    max_value=$current_value
                fi
            fi
        done < "$file"

        # 删除所有重复的条目并添加包含最大值的条目
        sed -i "/^${steamid}:/d" "$file"
        echo "${steamid}:${max_value}" >> "$file"
    done
}

# 定期处理文件
while true; do
    DuplicateInfoUpdate "$ReservedUserInfo"
    DuplicateInfoUpdate "$SignVIPUserInfo"
	DuplicateInfoUpdate "$PointsUserInfo"
    sleep 300
done

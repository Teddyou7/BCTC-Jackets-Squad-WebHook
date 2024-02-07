#!/bin/bash
#积分控制脚本
#1=steamid 2=增加或删除 3=操作金额 4=备注
#${WBHKHOME}/bin/shell/additional/transaction_manager.sh "steamid" "add" "100" "交易备注"
#${WBHKHOME}/bin/shell/additional/transaction_manager.sh "steamid" "del" "100" "交易备注"

#设置语言环境
export LANG=en_US.UTF-8

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

# 锁文件路径
lock_file="/tmp/transactions.lock"

# 设置最大等待次数
max_wait=300
wait_count=0

# 检查锁文件，等待解锁
while [ -f "$lock_file" ]; do
    if [ "$wait_count" -ge "$max_wait" ]; then
        echo "Maximum wait time exceeded. Exiting."
        exit 1
    fi
    #echo "Another instance is running. Waiting for the lock to be released..."
    sleep 0.1  # 等待100毫秒后再次检查
    wait_count=$((wait_count+1))
done

# 创建锁文件
touch "$lock_file"

# 清理锁文件
trap 'rm -f "$lock_file"; exit' INT TERM EXIT

# 解析参数
organization_tag=$db_tag
steamid="$1"
operation="$2"
amount="$3"
note="$4"

# 检查必要的参数
if [[ -z "$organization_tag" || -z "$steamid" || -z "$operation" || -z "$amount" ]]; then
    echo "Missing required arguments. Exiting."
    rm -f "$lock_file"
    exit 1
fi

# 连接数据库并查询最新余额
current_balance=$($mysql_cmd "SELECT current_balance FROM transactions WHERE steamid='$steamid' AND organization_tag='$organization_tag' ORDER BY transaction_time DESC LIMIT 1;")


# 如果没有找到记录，将余额设置为0
if [[ -z "$current_balance" ]]; then
    current_balance=0
fi

# 根据操作类型更新余额
if [ "$operation" == "add" ]; then
    new_balance=$(echo "$current_balance + $amount" | bc)
elif [ "$operation" == "del" ]; then
    new_balance=$(echo "$current_balance - $amount" | bc)
else
    echo "Invalid operation type. Must be 'add' or 'del'. Exiting."
    rm -f "$lock_file"
    exit 1
fi

# 向数据库写入新记录
$mysql_cmd  "INSERT INTO transactions (steamid, organization_tag, transaction_amount, current_balance, type, note) VALUES ('$steamid', '$organization_tag', '$amount', '$new_balance', IF('$operation' = 'add', 1, 0), '$note');"

# 移除锁文件
rm -f "$lock_file"

echo "$new_balance"
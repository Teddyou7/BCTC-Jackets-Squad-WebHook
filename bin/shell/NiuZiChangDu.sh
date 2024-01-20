#!/bin/bash
#NiuZiChangDu.sh
#牛子长度  "${player_name}%%${player_steamID}%%${ServerID}" 
player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
ServerID=$(echo $1|awk -F '%%' '{print $3}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

if [ $NiuZiChangDuIf -eq 0 ]; then
	PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)
	$CMDSH AdminWarnById $PlayerID 服务器管理员已禁用了“牛子长度”功能！
	exit
fi

find ${WBHKHOME}/date/tmp/NiuZi/$player_steamID -type f -mmin +$NiuZiChangDuTimeTmp -delete

# 检查文件是否存在
if [ -e "${WBHKHOME}/date/tmp/NiuZi/$player_steamID" ]; then
	NiuziLength=$(cat ${WBHKHOME}/date/tmp/NiuZi/$player_steamID)
	NiuziLengthFile=1
else
	# 生成一个 0 到 1 之间的随机小数
	rand=$(awk -v seed="$RANDOM" 'BEGIN { srand(seed); print rand() }')
	# 使用非线性函数调整随机数分布，这里使用平方
	adjusted_rand=$(echo "$rand^2" | bc -l)
	# 将调整后的随机数映射到 10 到 50 的范围
	# 82 * adjusted_rand + 12 转换到 12 到 82 的范围
	random_num=$(echo "30 * $adjusted_rand + 6" | bc -l)
	# 保留三位小数
	formatted_num=$(printf "%.3f" $random_num)
	NiuziLength=$formatted_num
	echo $NiuziLength > ${WBHKHOME}/date/tmp/NiuZi/$player_steamID
	NiuziLengthFile=2
fi

dir_path="${WBHKHOME}/date/tmp/NiuZi"
file_to_check="${dir_path}/${player_steamID}"

# 从所有文件中提取数字，并进行排序
sorted_numbers=$(awk '{print $1}' "${dir_path}"/* | sort -nr)

# 计算总的数字数量
total_numbers=$(echo "$sorted_numbers" | wc -l)

# 从特定文件中提取数字
number_in_file=$(awk '{print $1}' "$file_to_check")

# 计算排名
rank=$(echo "$sorted_numbers" | awk -v num="$number_in_file" '{if ($1 == num) {print NR; exit}}')

if [ $NiuziLengthFile -eq 1 ]; then
	$CMDSH AdminBroadcast ${player_name}，的牛子长度为：${NiuziLength}cm，当前排名：${rank}/${total_numbers}
else
	$CMDSH AdminBroadcast ${player_name}，最新测量到的牛子长度为：${NiuziLength}cm！当前排名：${rank}/${total_numbers}
fi

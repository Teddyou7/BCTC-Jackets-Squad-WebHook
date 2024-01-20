#!/bin/bash
#TeamKill.sh

# 检查是否传入参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_string>"
    exit 1
fi

# 输入字符串，假设由$1传入
input_string=$1

# 以%%分隔输入字符串，并存储到数组中
IFS='%%' read -ra ADDR <<< "$input_string"

# 处理每个分割后的字符串
for i in "${ADDR[@]}"; do
    # 使用case语句匹配触发条件
    case $i in
        *condition1*|*condition2*) # 条件1和条件2
            # 调用相同的程序
            ./same_program "args_for_1_and_2"
            ;;
        *condition3*) # 条件3
            # 调用另一个程序
            ./another_program "args3"
            ;;
        # ... 添加更多条件 ...
        *) # 默认情况
            echo "No condition matched for $i"
            ;;
    esac
done

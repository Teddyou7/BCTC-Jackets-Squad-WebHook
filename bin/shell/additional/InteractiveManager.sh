#!/bin/bash

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh 

# 定义退出和清理操作
cleanup() {
    echo "插件系统被关闭！"
    # 初始化进度条
    echo -n "Closing "
    # 设定进度条长度
    progress_length=20
    for ((i=0; i<$progress_length; i++)); do
        echo -n '#'
        sleep 0.1  
    done
    echo " Done!"
    echo "Bay!"

    kill -9 `ps -ef|grep ${WBHKHOME} |grep -v grep|awk '{print $2}'` > /dev/null 2>&1 &
    exit
}

# 设置 SIGINT 信号的处理器
trap cleanup SIGINT

# 定义帮助信息
help_info() {
    echo "可用命令："
    echo "  log - 滚动查看插件系统日志。"
    echo "  http_file_server_log - 滚动查看远程权限列表日志"
    echo "  exit or quit - 退出并关闭插件系统"
    echo "  help - 显示帮助信息"
}

# 日志查看函数
tail_log() {
    # 当按下 ^C 时，打印信息并退出 tail 命令
    trap 'echo "停止查看日志。"; break 2' SIGINT
    tail -f "$1"
    trap - SIGINT
}

# 主循环
while true; do
    echo -n "> "
    read -e CMD

    # 如果输入为空，继续下一个循环
    if [[ -z "$CMD" ]]; then
        continue
    fi

    case $CMD in
        "log")
            tail_log "${WBHKHOME}/log"
            ;;
        "http_file_server_log")
            tail_log "${WBHKHOME}/logs/webhook/http_file_server.log"
            ;;
        "help")
            help_info
            ;;
        "exit"|"quit")
            cleanup
            break
            ;;
        *)
            echo "未知命令。输入 'help' 查看命令列表。"
            ;;
    esac
done

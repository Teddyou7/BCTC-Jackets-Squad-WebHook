#!/bin/bash
source $(echo $(cd `dirname $0`; pwd))/cfg/config.sh

# 服务器上版本信息和索引文件的URL
VERSION_URL="http://$HOSTIPPORT/Version.txt?key=$UPDATEKEY"
INDEX_URL="http://$HOSTIPPORT/index.txt?key=$UPDATEKEY"

LOCAL_VERSION_FILE="${WBHKHOME}/Version"
DOWNLOAD_DIR=${WBHKHOME}

wget -q -O ${WBHKHOME}/date/tmp/version.txt $VERSION_URL
if [ "$(cat ${WBHKHOME}/date/tmp/version.txt)" != "$(cat $LOCAL_VERSION_FILE)" ]; then
    wget -q -O ${WBHKHOME}/date/tmp/index $INDEX_URL

        while IFS= read -r line; do
                # 检查是否为目录
                if [[ "$line" == */ ]]; then
                        mkdir -p "$DOWNLOAD_DIR/$line"
                else
                        # 确保文件所在目录存在
                        mkdir -p "$DOWNLOAD_DIR/$(dirname "$line")"
                        # 下载文件
                        echo "Downloading $line ..."
                        wget -q -O "$DOWNLOAD_DIR/$line" "http://$HOSTIPPORT/$line?key=$UPDATEKEY"
                fi
        done < ${WBHKHOME}/date/tmp/index

    #$cp ${WBHKHOME}/date/tmp/version.txt $LOCAL_VERSION_FILE
else
    echo "Already up to date."
fi

rm ${WBHKHOME}/date/tmp/version.txt ${WBHKHOME}/date/tmp/index

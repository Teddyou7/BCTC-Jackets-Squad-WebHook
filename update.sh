#!/bin/bash
source $(echo $(cd `dirname $0`; pwd))/cfg/config.sh

# 服务器上版本信息和索引文件的URL
VERSION_URL="http://$HOSTIPPORT/Version.txt?key=$UPDATEKEY"
INDEX_URL="http://$HOSTIPPORT/index.txt?key=$UPDATEKEY"

LOCAL_VERSION_FILE="${WBHKHOME}/Version"
DOWNLOAD_DIR=${WBHKHOME}

wget -q -O ${WBHKHOME}/version.tmp $VERSION_URL

echo "Current $(cat $LOCAL_VERSION_FILE)"
echo "Server $(cat ${WBHKHOME}/version.tmp)"

if [ "$(cat ${WBHKHOME}/version.tmp)" != "$(cat $LOCAL_VERSION_FILE)" ]; then
    wget -q -O ${WBHKHOME}/upindex.tmp $INDEX_URL

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
        done < ${WBHKHOME}/upindex.tmp

    #$cp ${WBHKHOME}/version.tmp $LOCAL_VERSION_FILE
else
    echo "Already up to date."
fi

rm ${WBHKHOME}/version.tmp ${WBHKHOME}/upindex.tmp

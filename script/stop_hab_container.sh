#!/bin/sh

##############################################################
# コンテナ停止スクリプト
#
#   起動中のコンテナを停止します。
#   引数に down を指定することで、コンテナの削除も行います。
#
#   $ sh stop_rails_container.sh      -- 停止
#   $ sh stop_rails_container.sh down -- 停止 & 削除
#
##############################################################

COMMAND_RESULT=`docker-compose ps -q`

# コンテナが存在しない場合は何もしない
if [ '' == "$COMMAND_RESULT" ] ; then
  exit 0
fi

# コンテナを停止
docker-compose stop

# 引数に down が指定されている場合は、コンテナを削除
if [ "$1" == 'down' ] ; then
  docker-compose down -v
fi

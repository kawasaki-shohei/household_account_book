#!/bin/sh

##############################################################
# コンテナ起動スクリプト
#
#   webサーバとdbサーバのコンテナを起動します。
#
#   $ sh start_rails_container.sh
#
##############################################################

COMMAND_RESULT=`docker-compose ps -q`

if [ '' == "$COMMAND_RESULT" ] ; then

    # バックグラウンドで起動
    docker-compose up -d

    # アセッツコンパイル
    docker-compose exec web rails assets:precompile RAILS_ENV=staging

    # DB作成
    docker-compose exec web rails db:create

    # マイグレーション
    docker-compose exec web rails db:migrate

    # rails再起動
    docker-compose exec web rails restart

else

    # バックグラウンドで起動のみ
    docker-compose up -d

fi


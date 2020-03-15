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
    docker-compose up -d --build

    # テスト環境データベース作成
    docker-compose exec web rails db:create RAILS_ENV=test

    # テスト環境マイグレート
    docker-compose exec web rails db:migrate RAILS_ENV=test

    # テスト環境テストデータ投入
    docker-compose exec web rails db:seed_from_file SEED_FILENAME='seeds/00_category_masters_seeds.rb' RAILS_ENV=test

    # 開発環境マイグレーション
    docker-compose exec web rails db:migrate

    # 開発環境初期データ投入
    docker-compose exec web rails db:seeds

else

    # バックグラウンドで起動のみ
    docker-compose up -d --build

fi


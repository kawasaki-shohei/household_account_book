#!/bin/bash

cd /usr/src/household_account_book

# Bundle
bundle install

# package.jsonに記載されているパッケージのインストール
yarn install

RAILS_ENV=development rails db:migrate

# railsサーバー起動
#rails s -p 3000 -b '0.0.0.0'
#bundle exec rdebug-ide --port 1234 --dispatcher-port 26162 --host 0.0.0.0 -- bin/rails s -b 0.0.0.0 -p 3000
#
exit 0

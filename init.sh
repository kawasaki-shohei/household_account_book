#!/bin/bash

cd /usr/src/household_account_book

# Bundle
bundle install

# package.jsonに記載されているパッケージのインストール
yarn install

RAILS_ENV=development rails db:migrate

# railsサーバー起動
rails s -p 3000 -b '0.0.0.0'

exit 0

# README

[![ruby version](https://img.shields.io/badge/Ruby-v2.5.1-red.svg)](https://www.ruby-lang.org/ja/)
[![rails version](https://img.shields.io/badge/Rails-v5.2.2.1-critical.svg)](http://rubyonrails.org/)
[![PostgreSQL version](https://img.shields.io/badge/PostgreSQL-v10.6-blue.svg)](https://www.postgresql.org/)
[![React version](https://img.shields.io/badge/React-v16.8.6-green.svg)](https://reactjs.org/)

## アプリ名: PairMoney
アプリURL: https://pairmoney.herokuapp.com/

## アプリ概要
夫婦またはカップル専用の家計簿webアプリケーション。  
簡単な出費の入力で、複雑な二人の出費を管理できる。  

## コンセプト
夫婦やカップルでも財布を分けて管理したい人をターゲットとしている。  
毎日の食費や日用品などの家族のための出費を記録すると、１ヶ月単位で精算金額を自動的に計算してくれる。  

## 使用技術
- フロントエンド
  - Bootstrap 3.3.7
  - jQuery 3.2.1
  - AdminLTE 2.4.5
  - React 16.8.6 (電卓機能のみ)
  - React Redux 7.0.3 (電卓機能のみ)
- サーバーサイド
  - Ruby 2.5.1
  - Ruby on Rails 5.2.2.1
- データベース
  - PostgreSQL 10.6
- 本番環境 & ステージング環境
  - Heroku

## 実装機能
- ユーザー登録機能
- ログイン機能
- パートナー登録機能
- カテゴリー登録機能
- 予算登録機能
- 出費登録機能
- 電卓機能
- 収入登録機能
- 収支バランス自動計算機能
- 出費分析機能
- 二人の貯金登録機能
- 手渡し料金登録機能
- 精算金額計算機能
- 繰り返し出費登録機能
- 通知機能
- パートナーレコード閲覧モード

詳しくは[こちらのWiki](https://github.com/shoooohei/household_account_book/wiki)を参照

## ER図
![er](https://github.com/shoooohei/household_account_book/blob/master/erd.png)

## 対応ブラウザ
- MacOS Google Chrome
- Google Chrome for Android

## 気をつけたポイント
- ステージング環境を用意して、本番環境にデプロイする前に動作確認している。
- バージョンをあげて、credentials.yml.encを使えるようにした。
- formは全て`form_with`を使って、XSSやCSRFに注意している。
- SQLインジェクションに注意して、ActiveRecordのwhereメソッドの引数にはplaceholderを使っている。
- 脆弱性対応
  脆弱性が報告されたため、Rails 5.2.2.1へjQueryを3.4.0へバージョンアップした。  
  Ruby 2.5.1 にも脆弱性が報告されているため、バージョンアップする予定。
- ActiveRecordが発行するSQLを理解して、N+1問題の解決に努力している。
- Decoratorを導入して、ビューで使うロジックをModelから切り離している。
- ER図の自動更新  
  gem rails-erdを使い、migrateの実行をフックして、ER図が自動的に更新されるようにしている。
- migrate実行時にモデルにカラム情報を自動的に記載するようにしている。
- アセッツ  
  Railsのデフォルトで全てのアセッツを全てのページで読み込むのは、性能が悪く、加えてクラス名やid名の衝突にもなる。  
  基本的に全てのページで必要になるBootstrapやjQuery以外は、各ページで読み込むCSSとJSを指定している。
- わかりにくいカラム名の変更
  - expenses.both_flg → expenses.is_for_both  
    二人の出費かどうかを判断するexpensesテーブルの`[Boolean] both_flg`は`if expense.both_flg`としたときに、trueなのかfalseなのかわかりにくい。  
    `is_for_both`とすることで`if expense.is_for_both`としたときに、`二人の出費だったら`と意味だとわかりやすくなった。
  - categories.kind → categories.name  
    他のテーブルではnameを使用していたため統一した。
- DateクラスとStringクラスにメソッドを追加  
  月単位でロジックを組むことが多いので、 `"2019-08".to_beginning_of_month => Thu, 01 Aug 2019`のように簡単に変換できるように、DateクラスとStringクラスにメソッドを追加して、どこからでも呼び出せるようにしている。
- Date.currentを使用して、タイムゾーンの誤差がでないようにしている。

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author

[shoooohei](https://github.com/shoooohei)

Household Account Book For Couples
====
https://pairmoney.herokuapp.com/

## Description
PairMoneyは、夫婦またはカップル専用の家計簿webアプリケーションです。  
簡単な出費の入力で、複雑な二人の出費を管理できます。  

## Requirement
- Ruby 2.5.1
- Rails 5.2.2
- PostgreSQL 10.6

## Function
- カテゴリーのCRUD処理
- 予算のCRUD処理
- 出費のCRUD処理
- 二人の貯金のCRUD処理
- 収入のCRUD処理
- 精算金額計算機能
- 手渡し料金のCRUD処理
- 繰り返し出費のCRUD処理
- ほしい物リストCRUD処理
- パートナーレコード閲覧モード
- 設定管理機能
- 管理画面機能
詳しくは[こちらのWiki](https://github.com/shoooohei/household_account_book/wiki/%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AE%E6%A6%82%E8%A6%81)を参照

## Comming Soon
- 子カテゴリ機能

## ER Diagram
![er](https://github.com/shoooohei/household_account_book/blob/master/erd.png)

## Usage
1. PostgreSQLをインストール

1. Gem のインストール
```
$ bundle install
```

1. AdminLTEのインストール
```
yarn add admin-lte@2.4.5
```

1. jquery-ui-touch-punchのインストール
タッチに操作に対応させるため。
https://github.com/furf/jquery-ui-touch-punch
```
yarn add jquery-ui-touch-punch
```

1. データベースの構築
```
$ rails db:create
$ rails db:migrate
```

1. テストデータの挿入
```
rails db:seeds
```

上記が上手く動かなかった場合、ファイルを指定してテストデータを挿入できます。
```
rails db:seed_from_file SEED_FILENAME='ファイル名(/db/配下からのパス付き)'
```

1. Railsサーバー起動
```
$ rails server
```

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author

[shoooohei](https://github.com/shoooohei)

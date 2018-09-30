Household Account Book For Couples
====
https://habfoc.herokuapp.com/

## Description
カップルの財布を別にして、カップルの出費を管理できる家計簿Webアプリです。
簡単な出費の入力で複雑な二人の出費を計算できます。

## Requirement
- Ruby 2.3.0
- Rails 5.1.4
- PostgreSQL 10.1
- Bootstrap 4

## Function
- 出費のCRUD処理
- カテゴリのCRUD処理
- 予算のCRUD処理
- 手渡し料金のCRUD処理
- 繰り返し出費のCRUD処理
- ほしい物リストCRUD処理
- 設定管理機能
詳しくは[こちらのWiki](https://github.com/shoooohei/household_account_book/wiki/%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AE%E6%A6%82%E8%A6%81)を参照

## Comming Soon
- 子カテゴリ機能

## ER Diagram
![er](https://github.com/shoooohei/household_account_book/blob/master/erd.png)

## Usage
このアプリケーションを動かす場合は、まずはリポジトリをクローンしてください。

```
$ git clone git@github.com:shoooohei/household_account_book.git
```

Gems のインストール

```
$ bundle install
```

データベースの構築

```
$ rails db:create
$ rails db:migrate
```

テストデータの挿入
```
rails db:seeds
```

上記が上手く動かなかった場合、ファイルを指定してテストデータを挿入できます。
```
rails db:seed_from_file SEED_FILENAME='ファイル名(/db/配下からのパス付き)'
```

Railsサーバー起動

```
$ rails server
```

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author

[shoooohei](https://github.com/shoooohei)

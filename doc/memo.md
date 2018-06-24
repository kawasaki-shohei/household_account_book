bothからconfirmに飛んでも、confirmからのback buttonがnewに飛んでしまっているから
それを変更する必要がある
→done

expenseの並び順はdateの次にcreated_atでも並び変えられるように
→同じ日だと順番が違ってくる
→done

出費を編集・削除できるように
→aloneはできたbothができているか確認。そのあとは、delete

partners_controllerのcheck_existance
→done
user#showでpartnerがnilだとエラーになるからif文でエラーがでないように→done

カテゴリの編集・削除
次はcategory#edit　編集・削除・はずすを選択できるように

category#index
  自分の全てのカテゴリを表示(編集のリンク)
  共通のカテゴリに登録しているパートナーのカテゴリ一覧(共通カテゴリの解除のリンク)
  共通のカテゴリを登録のリンク
  新しいカテゴリを追加のリンク

共通のカテゴリを登録
  今の共通のカテゴリを選ぶ画面と同じ
  indexに戻るボタン

編集ページ(new or edit)
  new　新しいカテゴリを追加
    フォーム
    チェックボックス　パートナーと共通のカテゴリにする
    indexに戻るボタン
    →ここまで終わった
  edit カテゴリを編集
    フォームでカテゴリ名の編集
    削除リンク

削除 or 共通カテゴリの解除ページ
  代わりのカテゴリを選ぶ
  新しいカテゴリを追加リンク
ここは保留

■前後月ボタン
.month_ago() .month_since()とかでできそう
引数を変数にして、ajaxで足したり引いたりすればできるかも

1.routingに追加
  pastとfutureをgetメソッドで


2. expenses#indexのviewを前月のリンクと来月のリンクを追加
リンクに以下のように変数を仕込んでおく。
  前月へ(x) 来月へ(y)
  デフォルトはx = 1, y=1


3.controllerのpast/futureアクションでparamsからの変数をつかって、month_ago()メソッドなどで１ヶ月前などのデータを取得する。
controllerにベタ打ちのほうが簡単だけど、名前付きスコープに引数を渡すやり方でできそう。
ただ、スコープに変数を渡すのではなく、スコープに入れる前の変数定義にviewからのパラメーターを渡せればできそう。
    end_of_month = Date.today.end_of_month
    beginning_of_month = Date.today.beginning_of_month
    scope :past_month, -> {where('date >= ? AND date <= ?', beginning_of_month, end_of_month)}
    ここの、
    beginning_of_month = Date.today.beginning_of_month
    ↓
    beginning_of_past_month = Date.today.month_ago(x).beginning_of_month　　とか

    でもどうやったら、modelの変数定義に変数を渡せるかわからないので、まずはベタ打ちで良さそう。
→とりあえずできた。


■手渡し料金
二人の出費の内、
  手渡し料金 = 自分が払ったお金 - 相手が払ったお金のうち自分が払わなければいけないお金 - 今までに手渡したお金
  current_user_expenses.both_t.sum(:amount) - partner_expenses_of_both.both_t.sum(:parnerpay) -

今月の払わなければいけない手渡し料金のロジックをつくった。確認が必要

■会員登録した後パートナーを登録する画面へ
partnerメソッドを引数なしに変えたから、全てのページで動くかどうかの確認。
あと、if文で分けてたところをpartnerがすでにいる状態へしていけば、すっきりすると思う
引数が影響しないことが確認できたら、before_actionでpartnerをつけ加えると、current_userのようにpartnerが使えるようになる。

■コントローラーの計算式は全部modelに書いて、コントローラーからはメソッドとして呼び出す。

■デプロイ後
・ユーザー画面でパートナーが表示されていない

・サインアップ画面とユーザー画面のフロント

・ログインしていない場合はサインアップではなく、ログイン画面へ遷移するように

・ナブバーの文字が小さい

・ボタンの幅大きく

・confirm画面のボタンをblockに

・確認から戻るを押すとエラーが出てる

・noticeに単位が付いていない

・Pay newの日付がおかしい
→ f.date_select :date, discard_day
で年と月だけ選べる

・ボタンがアクティブにならない

・カテゴリーが０の場合に、出費を入力しようとするときは、alartに「カテゴリーを一つ以上入力してください。」とつけて、カテゴリーを入力する画面に遷移させる

・なぜか以下のif文の最初の方のものが実行されてしまう
@cnum = 0
if @cum != 0
  past_and_future(@cnum)
elsif @cnum == 0
  redirect_to expenses_path
end

■devのpgのレコード削除
```rb
tables = [Badget, Category, Expense]
tables.each do |table|
  table.destroy_all
end
```

■Heroku
https://qiita.com/akiko-pusu/items/305e291465d6aac04bf3

■Herokuからのcsv出力方法
1. git remote add herokku ~~~.git　でherokuのgitを登録しておく
2. heroku loginでログインする
3. heroku pg:psql -c "\copy (select * from テーブル名) to ファイル名.csv with csv header"
でcsv出力。rootディレクトリ直下に保存される
4. cat ファイル名で中身を確認できる

```bash
tables=("categories" "badgets" "expenses" "repeat_expenses" "pays" "wants" "notification_messages" "notifications" "deleted_records")

i=0
for table in ${tables[@]}; do
heroku pg:psql -c "\copy (select * from ${table}) to db/${table}.csv with csv header"
let i++
done

heroku pg:psql -c "\copy (select * from badgets) to db/badgets.csv with csv header"
heroku pg:psql -c "\copy (select * from categories) to db/categories.csv with csv header"
heroku pg:psql -c "\copy (select * from expenses) to db/expenses.csv with csv header"
heroku pg:psql -c "\copy (select * from pays) to db/pays.csv with csv header"
```

■idのクリア
```rb
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

ActiveRecord::Base.connection.execute("SELECT setval('expenses_id_seq', coalesce((SELECT MAX(id)+1 FROM expenses), 1), false)")
```

■seeds.rbの使い方
https://www.sejuku.net/blog/28395
http://itmemo.net-luck.com/rails-seed/
http://sakura-bird1.hatenablog.com/entry/2017/02/26/214648

```rb
require 'csv'
<<<<<<< HEAD

tables=["categories", "badgets", "repeat_expenses", "expenses", "pays", "wants", "notification_messages", "notifications", "deleted_records"]
tables.each do |t|
  csv_data = CSV.read("db/#{t}.csv", headers: true)
  csv_data.each do |data|
    (t.classify.constantize).create!(data.to_hash)
  end
end

tables = [Category, Badget, RepeatExpense, Expense, Pay, Want, NotificationMessage, Notification, DeletedRecord]
tables.each do |t|
  csv_data = CSV.read("db/#{t.table_name}.csv", headers: true)
  csv_data.each do |data|
    t.create!(data.to_hash)
  end
end

csv_data = CSV.read('db/postal_code_tokyo_with_header.csv', headers: true)
csv_data.each do |data|
  PostalCode.create!(data.to_hash)
end
```

■shift_moneth
category_ids.nil? category_ids.present? 両方falseになってしまう。


~~・updateのとき日付が今日になる~~
~~・updateからconfirmに飛んでない~~
~~・confirmの戻るボタンに色がついていない~~
~~・both listでカテゴリ別の出費が日付の昇順になっている→降順に~~

■毎月のループ
https://qiita.com/ryounagaoka/items/97bacfda75b9fd7e050b

■date_selectの取得方法
```ruby
[1] pry(#<TestsController>)> params
=> <ActionController::Parameters {"utf8"=>"✓", "authenticity_token"=>"jPyxEPq6oGtEUsTRrGfPICmecC8b1rwZC/HTI/KHXpDzFRL4kX37StLUXZqgNDPayV6FCE82p/IhoDdOPBfNdg==", "test"=>{"amount"=>"1000", "date(1i)"=>"2018", "date(2i)"=>"5", "date(3i)"=>"1", "date2(1i)"=>"2018", "date2(2i)"=>"5", "date2(3i)"=>"12"}, "commit"=>"Create Test", "controller"=>"tests", "action"=>"create"} permitted: false>
[2] pry(#<TestsController>)> params[:test][:date]
=> nil
[3] pry(#<TestsController>)> params[:test][:date1]
=> nil
[6] pry(#<TestsController>)> params[:test]["date(1i)"]
=> "2018"
```
これでも取れる
```ruby
[1] pry(#<PaysController>)> params
=> <ActionController::Parameters {"utf8"=>"✓","authenticity_token"=>"oeNbZLMUDjoC2wCAcdaXXOAM/LZFBmhRPD1+mq0wS61yBr7E2mKuMtpeGSA8E26sIGWpjnqJl26H2vK26M2VvQ==", "pay"=>{"pamount"=>"1000", "date(1i)"=>"2018", "date(2i)"=>"5", "date(3i)"=>"1", "memo"=>""}, "commit"=>"追加", "controller"=>"pays", "action"=>"create"} permitted: false>
[2] pry(#<PaysController>)> params.require(:pay).permit(:pamount, :date, :memo)
=> <ActionController::Parameters {"pamount"=>"1000", "date(1i)"=>"2018", "date(2i)"=>"5", "date(3i)"=>"1", "memo"=>""} permitted: true>
```


■[1,10].uniq!メソッドでエラーが出る。
→uniq!メソッドは、配列の中で重複する要素を削除します。レシーバ自身を変更するメソッドです。戻り値は、変更があったときはレシーバ自身、なかったときはnilです。

html2haml app/views/layouts/application.html.erb application.html.haml

■repeat_expensesのconfirm実装
→ok

■やっぱり開始日が今日より過去日でも入力されるように。でもまずは、入力できるようにロジックを組む。

■expense updateの時にrepeat_expense_idをnilにする

■repeat_expense#update
基本的にレコードは消さない
・テーブルの変更
expenses
  1. repeat_expensesからのレコードの作成は金額やメモなどユーザーが変更可能なものはnilにする
  2. repeat_expense_idの枝番のカラムを加えてrepeat_expensesから参照するようにする
repeat_expenses
  1. idとsub_idで複合主キーを作る。
update時
  どのカラムが変わったかによって処理を変更する必要がある

■map
category_ids = (current_user_expenses.extract_category + current_user_expenses_of_both.extract_category + partner_expenses_of_both.extract_category)
↓
category_ids = @current_user_expenses + @current_user_expenses_of_both + @partner_expenses_of_both
category_ids.map{|i| i.category_id}

extract_categoryがいらなくなるから、処理が早くなる

■インスタンスメソッド内のself.カラムの使い方
  1. controllerで
    @current_user_expenses = current_user.expenses
    @partner_expenses = partner.expenses
    みたいなのでviewに渡す。
  2. modelでは
    def method
      self.col 〜〜
    end
    でデータを取得
  3. viewで
    @current_user_expenses.method
    で取得してデータを表示できる


■wants lists
モデル名：want
カラム
| id | user_id | name | buy_flg | memo |

■notifications
・モデル名 Notificaion
・通知されるアクション
    expense#create, update, destroy (bothのみ)
    repeat_expnese#create, update, destroy(bothのみ)
    want#create, update, destroy
    category#create, update
    pay#create, update, destroy
    controller_path
    action_name
・カラム
    | id | user_id | notified_by_id | notification_message_id | record_meta | read_flg |
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :notification_message, foreign_key: true
      t.integer :notified_by_id
      t.text :record_meta, null: false
      t.boolean :read_flg, default: false
      t.timestamps
    end
    userはcurrent_user
    引いてくるのはpartnerのもの
    destroyのときは消す前にdeleted_recordsテーブルにjsonでsave
    同時に
    その後、notified_by_idにdeleted_records_idがはいる

count使って通知数を表示。controllerを作って実装
destroyのときはレコードを消す前に移行する？
createやupdateはそのidがわかったら引いてこれると思ったけど、変更された後にまた変更されてしまった場合、前の値まで変更された値で表示してしまうから、やっぱり通知情報もjsonで保存していったほうがいい。

■NotificationMessage
・モデル名 NotificationMessage
・カラム
    | id | msg_id | func | act | msg |
    create_table :notification_messages do |t|
      t.string :func
      t.string :act
      t.text :msg
    end    

■deleted_records
・モデル名 DeletedRecord
・カラム
    | id | deleted_by | table_name | record_meta |
    create_table :deleted_records do |t|
      t.references :user, foreign_key: true
      t.string :table_name
      t.text :record_meta, null: false

      t.timestamps
    end
    rename_column :deleted_records, :user_id, :deleted_by

■レコードをHashにする
a.attributes

■レコードをjsonに
.to_json

■jsonをhash
JSON.parse(json)

■hash化された値を取り出す
a['key']

■毎月1日に支払い金額を通知したい
→メソッドを書いておいて、herokuのコンソールから実行できるみたい

notification_messagesのmsg_idカラムを追加それをprimary_keyに。notifications_helperもmsg_idを引くように
→ok

bought buttonの通知機能を実装中
notification_messages tableのmessageカラムを消去

shiftmonthsで出費リストに日付が出ない。
→終わったらexpenses, repeat_expenses, shiftmontsをリファクタリングして、繰り返し出費の表示を一番下に



■current_user_expenses
  self.both_f.newer

■partner_expenses.both_t.newer

■current_user_expenses_of_both → 要らない
  current_user_expenses → self.both_t.newer

■category_badgets → 要らないかも
  current_user.badgets

■category_sums
  current_user_expensesとpartner_expensesだけ送れば今とほとんど変わらずメソッドが使えるいいかも。だからクラスメソッドにしてやればいい。
■sum
  helperでもviewでもどっちでも

■both_sum


category_sumsなどのcurrent_userとpartnerの両方の出費を使うとなると、viewからどうやって呼びだすのが一番綺麗か？
インスタンスメソッドがいいから、
@all_expenses = current_user.expenses.this_month.or(partner.expenses.this_month.both_t)
を渡して、そこからインスタンスメソッドを作るとか

あと、helperでcurrent_userとか使えるのか？

単純に大元の@all_expensesをどの月かに合わせて変えて、viewに送ればあとはインスタンスメソッドで計算する計算式は全部同じなんじゃないか？→そうすればすごくシンプルになりそう。shiftmonthのロジックはほとんど要らないかも。

current_userやpartnerは分けてテンプレート変数にしたほうがいいのか？
  →しなければ、viewで切り分けるけど、どうやる？
    @all_expenses.for_current_user っていうメソッド使うとして、current_userを送らなければいけない。引数の指定しなければいけないから、全体的にコードが増えてしまう気がする。

そんなメリットあるか？
  →@all_expenses, @current_user_expenses, @partner_expensesの３つをテンプレート変数にすればいいんじゃないかな？

たくさん抜き出したレコードはインスタンスの集合体なので、インスタンスメソッドが使えない。
だからクラスメソッドにすればviewからでも使える。


■expenses#indexとrepeat_expenses#indexで使うviewは_expenses_list.html.haml
  ▽@current_user_expenses
    @partner_expenses
    modelでrepeat_expensesのレコードを省くいてviewから呼び出すか
    current_user_expenses.
    ・メリット

    ・デメリット

  ▽expensesでもrepeat_expensesでも４つのテンプレート変数を作って、viewに送るか?
    メソッド側で引数をオーバーライドできれば、一つのメソッドいけるかも？
    @current_user_expenses(mine,both)
    @partner_expenses(both)
    @current_user_repeat_expenses(mine,both)
    @partner_repeat_expenses(both)
    repeat_expenses controllerからはcontroller_pathで分岐する
    @current_user_expenses
    @partner_expenses
    shift_monthからはexpensesと同じで
    @current_user_expenses
    @partner_expenses
    @current_user_repeat_expenses
    @partner_repeat_expenses
    total_expendituresもロジック組み直し。
    ・メリット

    ・デメリット
      この場合だとsumなどの合計を計算するときに引数が増える


■_expenses_list.html.haml
editに飛ぶようにリンクを貼っているけど、
これリンク内でcontoroller_pathでif文を作ればmoduleでpathを作れれば、
controllerで分けているのがもっと見やすくなる。
あと最初の「自分の繰り返し出費を追加」とかはrepeat_expensesのviewに書いたらif文がいらない。
each文の中は
- next if controller.controller_name != "repeat_expenses" || expense.repeat_expense_id != nil
でスキップできるかも。できるだけそれぞれのコントローラーで振り分けるようにしたくない。
link_toは結局ビューヘルパー内でどうにかするんじゃなくて、helperモジュールでパスを指定する。

＠currnet_expensesと@partner_expensesを引数で渡せば全ての出費を並び変えてくれるメソッドを作成し、
indexを
.each.with_index(30) do |expense, i|
を使えば、

■_expenses_summary.html.haml
repeat_expensesはここは行かないから、expensesとshiftmonthsの時だけsumなどの計算ができればいい。

■extract_categoryは.mapを使うとめちゃくちゃ簡単に書ける。scopeを書かなくてもいい。

user = User.find(1)
a=user.expenses.newer.limit(3)
arr = [194, 223, 290]
a.arrange_by_ids(arr)

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

■seeds.rbの使い方
https://www.sejuku.net/blog/28395
http://itmemo.net-luck.com/rails-seed/
http://sakura-bird1.hatenablog.com/entry/2017/02/26/214648

require 'csv'

csv_data = CSV.read('db/postal_code_tokyo_with_header.csv', headers: true)
csv_data.each do |data|
  PostalCode.create!(data.to_hash)
end

■Heroku
https://qiita.com/akiko-pusu/items/305e291465d6aac04bf3

■Herokuからのcsv出力方法
1. git remote add herokku ~~~.git　でherokuのgitを登録しておく
2. heroku loginでログインする
3. heroku pg:psql -c "\copy (select * from テーブル名) to ファイル名.csv with csv header"
でcsv出力。rootディレクトリ直下に保存される
4. cat ファイル名で中身を確認できる

heroku pg:psql -c "\copy (select * from expenses) to expenses.csv with csv header"

■毎月のループ
https://qiita.com/ryounagaoka/items/97bacfda75b9fd7e050b

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

■shift_moneth
category_ids.nil? category_ids.present? 両方falseになってしまう。


~~・updateのとき日付が今日になる~~
~~・updateからconfirmに飛んでない~~
~~・confirmの戻るボタンに色がついていない~~
・both listでパートナーの出費が日付の昇順になっている→降順に

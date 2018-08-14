■Herokuからのcsv出力方法
1. git remote add herokku ~~~.git　でherokuのgitを登録しておく
2. heroku loginでログインする
3. `extract_data_from_production.sh`  
でcsv出力。rootディレクトリ直下に保存される
4. cat ファイル名で中身を確認できる

```bash
tables=("categories" "badgets" "expenses" "repeat_expenses" "pays" "wants" "notification_messages" "notifications" "deleted_records")

i=0
for table in ${tables[@]}; do
heroku pg:psql --app habfoc -c "\copy (select * from ${table}) to db/${table}.csv with csv header"
let i++
done

heroku pg:psql -c "\copy (select * from badgets) to db/badgets.csv with csv header"
heroku pg:psql -c "\copy (select * from expenses) to db/expenses.csv with csv header"
heroku pg:psql -c "\copy (select * from repeat_expenses) to db/repeat_expenses.csv with csv header"
heroku pg:psql -c "\copy (select * from categories) to db/categories.csv with csv header"
heroku pg:psql -c "\copy (select * from pays) to db/pays.csv with csv header"
```

■idのクリア
```rb
ActiveRecord::Base.connection.tables.each do |t|
     ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

ActiveRecord::Base.connection.execute("SELECT setval('expenses_id_seq', coalesce((SELECT MAX(id)+1 FROM expenses), 1), false)")
```

■ローカルデータの削除  
```rb
tables = [Badget, RepeatExpense, Expense, Category, Pay, Want, Notification, NotificationMessage, DeletedRecord]
tables.each do |table|
  a = table.all
  a.destroy_all
end
```
■seeds.rbの使い方  
https://www.sejuku.net/blog/28395  
http://itmemo.net-luck.com/rails-seed/  
http://sakura-bird1.hatenablog.com/entry/2017/02/26/214648

```rb
require 'csv'

tables=["categories", "badgets", "repeat_expenses", "expenses", "pays", "wants", "notification_messages", "notifications", "deleted_records"]
tables.each do |t|
  csv_data = CSV.read("db/#{t}.csv", headers: true)
  csv_data.each do |data|
    (t.classify.constantize).create!(data.to_hash)
  end
end

tables = [Badget, RepeatExpense, Expense, Category, Pay, Want, Notification, NotificationMessage, DeletedRecord]
tables.each do |t|
  csv_data = CSV.read("db/#{t.table_name}.csv", headers: true)
  csv_data.each do |data|
    t.create!(data.to_hash)
  end
end
```

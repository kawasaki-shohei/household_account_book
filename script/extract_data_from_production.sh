#!/usr/bin/env bash
tables=("categories" "badgets" "expenses" "repeat_expenses" "pays" "wants" "notification_messages" "notifications" "incomes" "deposits" "balances" "deleted_records")

i=0
for table in ${tables[@]}; do
heroku pg:psql --app habfoc -c "\copy (select * from ${table}) to db/csv/${table}.csv with csv header"
let i++
done
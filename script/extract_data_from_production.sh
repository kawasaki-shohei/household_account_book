#!/usr/bin/env bash
tables=("categories" "budgets" "expenses" "repeat_expenses" "pays" "notification_messages" "notifications" "incomes" "deposits" "balances")

i=0
for table in ${tables[@]}; do
heroku pg:psql --app pairmoney -c "\copy (select * from ${table}) to db/csv/${table}.csv with csv header"
let i++
done
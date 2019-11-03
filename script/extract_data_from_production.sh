#!/usr/bin/env bash
tables=("categories" "budgets" "expenses" "repeat_expenses" "pays" "notifications" "incomes" "deposits" "balances")

i=0
for table in ${tables[@]}; do
heroku pg:psql --app pairmoney -c "\copy (select * from ${table} where user_id in (1, 2)) to db/csv/${table}.csv with csv header"
let i++
done
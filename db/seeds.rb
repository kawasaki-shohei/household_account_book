require 'csv'

def delete_all_and_reset_pk_sequence(table)
  puts "executing - delete all data in #{table} table"
  if table == "repeat_expenses"
    table.classify.constantize.with_deleted.each { |record| record.delete }
  else
    table.classify.constantize.all.each { |record| record.delete }
  end
  one_table_reset_pk_sequence(table)
end

# プライマリーキーのシーケンスをリセット
def one_table_reset_pk_sequence(table)
  puts "executing - reset_pk_sequence! #{table} table"
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

# データを入れたいテーブルを選択。ほとんどのテーブルがユーザーにネスとしているため、user_idが1と2のユーザーが必要。
# 全てのテーブル
# tables = [Category, Budget, Balance, RepeatExpense, Expense, Pay, Income, Deposit, NotificationMessage, Notification]
puts "starting - #{__FILE__}"
tables = [Category, Budget, Balance, RepeatExpense, Expense, Pay, Income, Deposit, Notification]

# 全テーブルの全てのレコードを削除し、プライマリーキーのシーケンスをリセットする。
ActiveRecord::Base.transaction do
  tables.map(&:table_name).reverse.each do |table|
    delete_all_and_reset_pk_sequence(table)
  end
end

# 本番から抽出したデータ(csv)からレコードをインサートする。
# Expense と Income のafter_commit コールバックが走って、無駄にBalanceCalculatorが行われてエラーになるため、Expense と Income のafter_commit コールバックをコメントアウトする
ActiveRecord::Base.transaction do
  tables.each do |table|
    puts "-------------------------------------"
    puts "seeding - table: #{table}"
    puts "-------------------------------------"
    csv_data = CSV.read("db/csv/#{table.table_name}.csv", headers: true)
    csv_data.each do |data|
      puts "seeding - data: #{data} "
      table.create!(data.to_hash)
    end
  end
end

tables.map(&:table_name).reverse.each do |table|
  one_table_reset_pk_sequence(table)
end


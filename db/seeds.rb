require 'csv'

def delete_all_and_reset_pk_sequence(table)
  puts "executing - delete all data in #{table} table"
  table.classify.constantize.all.each { |record| record.delete }
  one_table_reset_pk_sequence(table)
end

def one_table_reset_pk_sequence(table)
  puts "executing - reset_pk_sequence! #{table} table"
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

# 全てのテーブル
# tables = [Category, Badget, Balance, RepeatExpense, Expense, Pay, Income, Deposit, Want, NotificationMessage, Notification, DeletedRecord]
puts "starding - #{__FILE__}"
tables = [Category, Badget, Balance, RepeatExpense, Expense, Pay, Income, Deposit, Want, NotificationMessage, Notification]

ActiveRecord::Base.transaction do
  tables.map(&:table_name).reverse.each do |table|
    delete_all_and_reset_pk_sequence(table)
  end
end

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


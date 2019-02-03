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

# tables = [Category, RepeatExpense, Expense]
puts "starding - #{__FILE__}"
tables = [Category, Badget, RepeatExpense, Expense, Pay, Want, NotificationMessage, Notification, DeletedRecord]

tables.map(&:table_name).reverse.each do |table|
  delete_all_and_reset_pk_sequence(table)
end

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

tables.map(&:table_name).reverse.each do |table|
  one_table_reset_pk_sequence(table)
end


# csv_data = CSV.read('db/categories.csv', headers: true)
# csv_data.each do |data|
#   Category.create!(data.to_hash)
# end
#
# csv_data = CSV.read('db/badgets.csv', headers: true)
# csv_data.each do |data|
#   Badget.create!(data.to_hash)
# end
#
# csv_data = CSV.read('db/repeat_expenses.csv', headers: true)
# csv_data.each do |data|
#   RepeatExpense.create!(data.to_hash)
# end
#
# csv_data = CSV.read('db/expenses.csv', headers: true)
# csv_data.each do |data|
#   Expense.create!(data.to_hash)
# end

# csv_data = CSV.read('db/pays.csv', headers: true)
# csv_data.each do |data|
#   Pay.create!(data.to_hash)
# end

# csv_data = CSV.read('db/notification_messages.csv', headers: true)
# csv_data.each do |data|
#   NotificationMessage.create!(data.to_hash)
# end

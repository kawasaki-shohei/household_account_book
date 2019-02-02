require 'csv'

# tables = [Category, RepeatExpense, Expense]
puts "starding - #{__FILE__}"
tables = [Category, Badget, RepeatExpense, Expense, Pay, Want, NotificationMessage, Notification, DeletedRecord]

tables.map(&:table_name).reverse.each do |t|
  puts "executing - delete all data in #{t} table"
  t.classify.constantize.all.each { |record| record.delete }
  puts "executing - reset_pk_sequence! #{t} table"
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

tables.each do |t|
  puts "-------------------------------------"
  puts "seeding - table: #{t}"
  puts "-------------------------------------"
  csv_data = CSV.read("db/csv/#{t.table_name}.csv", headers: true)
  csv_data.each do |data|
    puts "seeding - data: #{data} "
    t.create!(data.to_hash)
  end
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

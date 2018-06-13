require 'csv'

tables = [Category, Badget, RepeatExpense, Expense]
tables.each do |t|
  csv_data = CSV.read("db/#{t.table_name}.csv", headers: true)
  csv_data.each do |data|
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

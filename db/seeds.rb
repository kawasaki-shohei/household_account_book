require 'csv'

csv_data = CSV.read('db/expenses.csv', headers: true)
csv_data.each do |data|
  Expense.create!(data.to_hash)
end

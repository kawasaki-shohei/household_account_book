require 'csv'

csv_data = CSV.read('db/categories.csv', headers: true)
csv_data.each do |data|
  Category.create!(data.to_hash)
end

csv_data = CSV.read('db/badgets.csv', headers: true)
csv_data.each do |data|
  Badget.create!(data.to_hash)
end

Dir[Rails.root.join('lib/utilities/*.rb')].sort.each do |file|
  require file
end
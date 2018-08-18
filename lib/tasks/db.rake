namespace :db do
  desc 'Load the seed data from SEED_FILENAME'
  task :seed_from_file => 'db:abort_if_pending_migrations' do
    seed_file = File.join(Rails.root, 'db', ENV['SEED_FILENAME'])
    puts "seeding -- dummy_users"
    load(seed_file) if File.exist?(seed_file)
  end

  desc "Run all files in db/seeds directory"
  task seeds: :environment do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |filename|
      puts "seeding - #{filename}"
      load(filename)
    end
  end
end

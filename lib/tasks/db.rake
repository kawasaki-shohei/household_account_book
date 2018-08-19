namespace :db do
  desc 'Load the seed data from SEED_FILENAME'
  task :seed_from_file => 'db:abort_if_pending_migrations' do
    seed_file = File.join(Rails.root, 'db', ENV['SEED_FILENAME'])
    if File.exist?(seed_file)
      puts "seeding -- #{ENV['SEED_FILENAME']}"
      load(seed_file)
    else
      puts "the seed file does not exist."
    end
  end

  desc "Run all files in db/seeds directory"
  task seeds: :environment do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |filename|
      puts "seeding - #{filename}"
      load(filename)
    end
  end
end

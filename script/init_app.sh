rails db:migrate
rails db:seeds
rails db:create RAILS_ENV=test
rails db:migrate RAILS_ENV=test
rails db:seed_from_file SEED_FILENAME='seeds/00_category_masters_seeds.rb' RAILS_ENV=test
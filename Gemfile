source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

gem 'rails', '~> 5.2.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'haml-rails'
gem 'daemons', '~> 1.2', '>= 1.2.6'
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.3'
gem 'bcrypt', '3.1.11'
gem 'chart-js-rails', '~> 0.1.6'
gem 'bootstrap', '~> 4.1.3'
gem 'jquery-rails'
gem 'sprockets-rails', '~> 3.2', '>= 3.2.1'
gem 'settingslogic'
gem 'activerecord-import'
gem 'dotenv-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.1'
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'html2haml'
  gem 'spring-commands-rspec', '~> 1.0', '>= 1.0.4'
  gem 'yard', '~> 0.9.16'
  gem 'guard-yard', '~> 2.2', '>= 2.2.1'
  gem 'annotate'
  gem 'kramdown', :require => false
  gem 'rails-erd'
  gem 'schemadoc'
  gem 'ruby-graphviz'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

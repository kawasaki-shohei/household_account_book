source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.7'

gem 'rails', '6.1.3.1'
gem 'puma'

#Database
gem 'pg'
gem 'scenic'

# model
gem 'paranoia'

# about assets
gem 'sprockets-rails'
gem 'uglifier'
gem 'font-awesome-rails'
gem 'react-rails'
gem 'webpacker'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# about views
gem 'jbuilder'
gem 'active_decorator'
gem 'kaminari'
gem 'gon'
gem 'rails-i18n'
gem 'enum_help'

gem 'bcrypt'
gem 'faker'
gem 'slack-notifier'
gem 'settingslogic'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'debase'
  gem 'ruby-debug-ide'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'html2haml'
  gem 'spring-commands-rspec'
  gem 'yard'
  gem 'guard-yard'
  gem 'annotate'
  gem 'kramdown', :require => false
  gem 'rails-erd'
  gem 'schemadoc'
  gem 'ruby-graphviz'
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

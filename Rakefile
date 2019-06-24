# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

if Rails.env.development?
  Rake::Task['db:migrate'].enhance do
    Rake::Task['erd'].invoke
  end
  Rake::Task['db:rollback'].enhance do
    Rake::Task['erd'].invoke
  end
end
# config valid only for current version of Capistrano
lock '3.4.0'

set :application,   'api_site'
set :repo_url,      'git@github.com:kagd/R2D2.git'
set :scm,           :git
set :assets_roles,  %w{app web}
set :user,          "deploy"
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml .ruby-gemset .env config/secrets.yml config/puma.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  after  :finishing,    :restart
end

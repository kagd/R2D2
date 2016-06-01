set :stage, :production

## Servers we are going to deploy to ----------------------
server '159.203.78.230', user: 'deploy', roles: %w{app db}

set :whenever_command,      -> { [:bundle, :exec, :whenever] }
set :whenever_environment,  -> { fetch :rails_env, fetch(:stage, "production") }
set :whenever_identifier,   -> { "#{fetch(:application)}_#{fetch(:stage)}" }

## Server Settings ----------------------------------------
set :deploy_to, "/var/www/api_site"

## Git Configuration Settings -----------------------------
set :rails_env, 'production'
set :branch,    'master'

set :rvm_ruby_version, "2.2.1@#{ fetch :application } --create"
set :rvm_roles, [:app, :web]

after :'deploy:published', :'update:all'

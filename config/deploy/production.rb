set :state, :production

## Servers we are going to deploy to ----------------------
server '159.203.78.230', user: 'deploy', roles: %w{app db}

## Server Settings ----------------------------------------
set :deploy_to, "/var/www/api_site"

## Git Configuration Settings -----------------------------
set :rails_env, 'production'
set :branch,    'master'

set :rvm_ruby_version, "2.2.1@#{ fetch :application } --create"
set :rvm_roles, [:app, :web]

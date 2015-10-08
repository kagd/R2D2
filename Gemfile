source 'https://rubygems.org'

ruby '2.2.1'

gem 'rails',            '~> 4.2.0'
gem 'pg',               '~> 0.18.3'
gem 'puma',             '~> 2.11.0'
gem 'sidekiq',          '~> 3.3.2'
gem 'sidekiq-failures', '~> 0.4.3'
gem 'jbuilder',         '~> 2.0'
gem 'octokit',          '~> 3.0'
gem 'colorize',         '~> 0.7.3'
gem 'sinatra',          '>= 1.3.0', require: nil # for sidekiq ui
gem 'digital_opera',    '~> 0.0.14'
gem 'httparty',         '~> 0.13.3'
gem 'dotenv-rails',     '~> 2.0.2'
gem 'uglifier',         '>= 1.3.0'
gem "therubyracer",     '~> 0.12.2'
gem 'whenever',         '~> 0.9.4', require: false

group :development do
  # deployment
  gem 'capistrano',          '~> 3.4.0'
  gem 'capistrano-rvm',      '~> 0.1.1'
  gem 'capistrano-rails',    '~> 1.1'
  gem 'capistrano-bundler',  '~> 1.1.2'
  gem 'capistrano3-puma',    '~> 1.2.1'
end

group :development, :test do
  gem 'rspec-rails',          '~> 3.2.1'
  gem 'guard',                '~> 2.12.4'
  gem 'factory_girl_rails',   '~> 4.5.0'
  gem 'mocha',                '~> 1.1.0', require: false
  gem 'guard-rspec',          '~> 4.5.0'
  gem 'guard-spork',          '~> 2.1.0'
  gem 'spork-rails',          '~> 4.0.0'
  gem 'database_cleaner',     '~> 1.4.0'
  gem 'json_spec',            '~> 1.1.4'
end

group :test do
  gem 'vcr',                  '~> 2.9.3'
  gem 'webmock',              '~> 1.20.4' #used with VCR
end

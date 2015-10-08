# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
set :environment, ENV["WHENEVER_ENVIRONMENT"]
set :output,      ENV["WHENEVER_LOG_PATH"]

job_type :rake, 'cd :path && :environment_variable=:environment bundle exec rake :task --silent :output'

every 12.hours, roles: [:app] do
  rake "update:all"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

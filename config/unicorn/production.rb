# frozen_string_literal: true

app_path = '/srv/tramway_pro'
working_directory "#{app_path}/current"

worker_processes 1

listen app_path + '/shared/.sock', backlog: 64

timeout 30
# preload_app true

stderr_path "#{app_path}/current/log/unicorn.stderr.log"
stdout_path "#{app_path}/current/log/unicorn.stdout.log"

# FIXME
pid "#{app_path}/shared/tmp/pids/unicorn.pid"

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{working_directory}/Gemfile"
end

before_fork do |_server, _worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end

# Place in /config/puma/production.rb

rails_env = "production"
environment rails_env

app_dir = "/srv/tramway_pro" # Update me with your root rails app path
shared_dir = "#{app_dir}/shared/"

bind  "unix://#{shared_dir}/puma.sock"
pidfile "#{shared_dir}/puma.pid"
state_path "#{shared_dir}/puma.state"
directory "#{app_dir}/current"

stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

workers 2
threads 1,2

activate_control_app "unix://#{shared_dir}/pumactl.sock"

prune_bundler

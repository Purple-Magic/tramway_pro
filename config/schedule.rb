every 1.minute do
  command "bundle exec rails r /srv/tramway_pro/current/lib/podcasts_download/process.rb"
end

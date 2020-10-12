every 1.minute do
  command "bundle exec rails r #{Rails.root}/lib/podcasts_download/process.rb"
end

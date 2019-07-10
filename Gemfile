source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'tramway-admin', '1.13.0.3'
gem 'tramway-auth', '1.0.2.1'
gem 'tramway-conference', '1.8.13.1'
gem 'tramway-core', '1.11.2'
gem 'tramway-event', '1.9.15'
gem 'tramway-landing', '1.7.1.1'
gem 'tramway-news', '1.0.4.1'
gem 'tramway-page', '1.2.2'
gem 'tramway-partner', '1.0.3'
gem 'tramway-profiles', '1.3.1'
gem 'tramway-site', '0.1.0.3'
gem 'tramway-sport_school', '1.2.9'
gem 'tramway-user', '2.0'

#gem 'tramway-admin', path: '../tramway-dev/tramway-admin'
#gem 'tramway-auth', path: '../tramway-dev/tramway-auth'
#gem 'tramway-conference', path: '../tramway-dev/tramway-conference'
#gem 'tramway-core', path: '../tramway-dev/tramway-core'
#gem 'tramway-event', path: '../tramway-dev/tramway-event'
#gem 'tramway-landing', path: '../tramway-dev/tramway-landing'
#gem 'tramway-news', path: '../tramway-dev/tramway-news'
#gem 'tramway-page', path: '../tramway-dev/tramway-page'
#gem 'tramway-partner', path: '../tramway-dev/tramway-partner'
#gem 'tramway-profiles', path: '../tramway-dev/tramway-profiles'
#gem 'tramway-site', path: '../tramway-dev/tramway-site'
#gem 'tramway-sport_school', path: '../tramway-dev/tramway-sport_school'
#gem 'tramway-user', path: '../tramway-dev/tramway-user'

ruby '2.5.1'

gem 'rails', '~> 5.1.4'
gem 'pg', '0.21.0'
gem 'unicorn'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails'
gem 'sass-rails'
gem 'bootstrap', '~> 4.1.2'
gem 'audited', '>= 4.8.0'
gem 'simple_form'
gem 'font_awesome5_rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'reform-rails'
gem 'enumerize'
gem 'state_machine', github: 'seuros/state_machine'
gem 'bcrypt'
gem 'copyright_mafa'
gem 'trap'
gem 'kaminari'
gem 'bootstrap-kaminari-views', github: 'kalashnikovisme/bootstrap-kaminari-views', branch: :master
gem 'carrierwave'
gem 'mini_magick'
gem 'rmagick'
gem 'state_machine_buttons'
gem 'more_html_tags', '>= 0.2.0'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'config'
gem 'colorize'
gem 'bootstrap-datepicker-rails', github: 'kostia/bootstrap-datepicker-rails'
gem 'russia_regions', '0.0.6'
gem 'russian'
gem 'time_difference'
gem 'pg_search'
gem 'colorize'
gem 'ransack'

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.5'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'redactor-rails', github: 'glyph-fr/redactor-rails'

group :test do
  gem 'factory_bot_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'faker'
  gem 'database_cleaner'
  gem 'rspec-json_expectations'
  gem 'json_matchers', github: 'BBonifield/json_matchers', branch: 'bugfix/properly-support-record-errors'
  gem 'webmock'
  gem 'webdrivers'
end

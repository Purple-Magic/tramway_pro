# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.2.2'
gem 'rails', '7.0.4.3'

gem 'tramway', '0.1.2'
gem 'tramway-conference', '1.9.5.12'
gem 'tramway-event', '2.0.1'
gem 'tramway-export', '0.2.1.4'
gem 'tramway-landing', '3.3.0.11'
gem 'tramway-news', '1.0.4.6'
gem 'tramway-page', '1.6.0.6'
gem 'tramway-partner', '1.0.4.3'
gem 'tramway-profiles', '1.4.1.4'

# gem 'tramway-conference', path: '../tramway-dev/tramway-conference'
# gem 'tramway', path: '../tramway'
# gem 'tramway-event', path: '../tramway-event'
# gem 'tramway-export', path: '../tramway-dev/tramway-export'
# gem 'tramway-landing', path: '../tramway-dev/tramway-landing'
# gem 'tramway-news', path: '../tramway-dev/tramway-news'
# gem 'tramway-page', path: '../tramway-dev/tramway-page'
# gem 'tramway-partner', path: '../tramway-dev/tramway-partner'
# gem 'tramway-profiles', path: '../tramway-dev/tramway-profiles'

gem 'aasm', '5.2.0'
gem 'actionview', '>= 5.1.6.2'
gem 'active_median'
gem 'active_model_serializers', github: 'Shopify/active_model_serializers', ref: '03b3170'
gem 'awesome_print'
gem 'bcrypt'
gem 'bcrypt_pbkdf', '>= 1.0'
gem 'bigdecimal', '1.3.5'
gem 'bootstrap'
gem 'bootstrap-datepicker-rails', github: 'kostia/bootstrap-datepicker-rails'
gem 'bootstrap-kaminari-views', github: 'kalashnikovisme/bootstrap-kaminari-views', branch: :master
gem 'browser'
gem 'carrierwave', '2.2.2'
gem 'ckeditor', '4.2.4'
gem 'clipboard-rails'
gem 'coffee-rails'
gem 'colorize'
gem 'config'
gem 'copyright_mafa'
gem 'capit'
gem 'ed25519', '>= 1.2'
gem 'enumerize'
gem 'faraday', '1.5.1'
gem 'ffi', '>= 1.9.24'
gem 'font_awesome5_rails'
gem 'haml-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'kaminari'
gem 'knock'
gem 'loofah', '>= 2.3.1'
gem 'mimemagic', '0.4.3'
gem 'mini_magick', '>= 4.9.4'
gem 'more_html_tags', '>= 0.2.0'
gem 'net-scp'
gem 'net-ssh'
gem 'nokogiri', '>= 1.14.0'
gem 'open3'
gem 'paper_trail'
gem 'paranoia', '~> 2.2'
gem 'pg', '>= 1.4.5'
gem 'pg_search'
gem 'pry'
gem 'pry-nav'
gem 'puma'
gem 'rack', '>= 2.0.8'
gem 'rack-cors'
gem 'rails-html-sanitizer', '>= 1.0.4'
gem 'rake', '>= 12.3.3'
gem 'ransack'
gem 'react-rails'
gem 'redcarpet'
gem 'rmagick', '4.2.2'
gem 'russian'
gem 'safe_target_blank'
gem 'sass-rails', '6.0.0'
gem 'selectize-rails'
gem 'shortener'
gem 'sidekiq'
gem 'sidekiq-batch'
gem 'sidekiq-cron', '~> 1.1'
gem 'sidekiq-scheduler'
gem 'simple_form', '>= 5.0.0'
gem 'smart_buttons', '1.0.2'
gem 'sprockets', '>= 3.7.2'
gem 'state_machine_buttons', '2.0'
gem 'streamio-ffmpeg'
gem 'telegram-bot-ruby', '0.15.0'
gem 'time_difference', github: 'AlexWayfer/time_difference', branch: 'depfu/update/activesupport-7.0.4.3'
gem 'trap', '4.0'
gem 'uglifier'
gem 'uuid'
gem 'validates'
gem 'webpacker'
gem 'whenever', require: false
gem 'yt'

group :development do
  gem 'foreman'
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'launchy'
  gem 'listen', '>= 3.8.0'
  gem 'parallel_tests'
  gem 'reek'
  gem 'rspec-rails', '~> 6'
  gem 'rubocop', '1.18.3'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
end
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'redactor-rails', github: 'glyph-fr/redactor-rails'

group :test do
  gem 'capybara', '>= 3.38'
  gem 'capybara_helpers'
  gem 'factory_bot_rails', '>= 6.2.0'
  gem 'faker'
  gem 'json_api_test_helpers', '1.2.1.2'
  gem 'json_matchers', github: 'BBonifield/json_matchers', branch: 'bugfix/properly-support-record-errors'
  gem 'rspec-json_expectations'
  gem 'rspec-retry'
  gem 'rspec-sidekiq'
  gem 'sanitize'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'webdrivers', '4.2.0'
  gem 'webmock'
  gem 'whenever-test'
end

group :production do
  gem 'airbrake'
end

gem 'httparty', '~> 0.20.0'

gem "bootsnap", require: false

gem "aws-sdk-s3", "~> 1.121"

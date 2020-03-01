# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'
gem 'rails', '5.1.7'

# gem 'tramway-admin', '1.26'
# gem 'tramway-api', '1.7.0.4'
# gem 'tramway-auth', '1.1.0.2'
# gem 'tramway-conference', '1.9.0.1'
# gem 'tramway-core', '1.16.1.8'
# gem 'tramway-event', '1.10.0.1'
# gem 'tramway-export', '0.1.2'
# gem 'tramway-landing', '2.0.1.1'
# gem 'tramway-news', '1.0.4.3'
# gem 'tramway-page', '1.3.1.1'
# gem 'tramway-partner', '1.0.3.2'
# gem 'tramway-profiles', '1.3.2.4'
# gem 'tramway-site', '0.1.0.4'
# gem 'tramway-sport_school', '1.2.10.4'
# gem 'tramway-user', '2.1.2'

gem 'tramway-admin', path: '../tramway-dev/tramway-admin'
gem 'tramway-api', path: '../tramway-dev/tramway-api'
gem 'tramway-auth', path: '../tramway-dev/tramway-auth'
gem 'tramway-conference', path: '../tramway-dev/tramway-conference'
gem 'tramway-core', path: '../tramway-dev/tramway-core'
gem 'tramway-event', path: '../tramway-dev/tramway-event'
gem 'tramway-export', path: '../tramway-dev/tramway-export'
gem 'tramway-landing', path: '../tramway-dev/tramway-landing'
gem 'tramway-news', path: '../tramway-dev/tramway-news'
gem 'tramway-page', path: '../tramway-dev/tramway-page'
gem 'tramway-partner', path: '../tramway-dev/tramway-partner'
gem 'tramway-profiles', path: '../tramway-dev/tramway-profiles'
gem 'tramway-site', path: '../tramway-dev/tramway-site'
gem 'tramway-sport_school', path: '../tramway-dev/tramway-sport_school'
gem 'tramway-user', path: '../tramway-dev/tramway-user'

gem 'active_model_serializers', '0.10.5' # 0.10.6 breaks the returned json, need to investigate
gem 'audited', '>= 4.8.0'
gem 'bcrypt'
gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap-datepicker-rails', github: 'kostia/bootstrap-datepicker-rails'
gem 'bootstrap-kaminari-views', github: 'kalashnikovisme/bootstrap-kaminari-views', branch: :master
gem 'carrierwave'
gem 'ckeditor', '4.2.4'
gem 'clipboard-rails'
gem 'coffee-rails'
gem 'colorize'
gem 'config'
gem 'copyright_mafa'
gem 'enumerize'
gem 'font_awesome5_rails'
gem 'haml-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'kaminari'
gem 'knock'
gem "loofah", ">= 2.3.1"
gem "mini_magick", ">= 4.9.4"
gem 'more_html_tags', '>= 0.2.0'
gem "nokogiri", ">= 1.10.8"
gem 'pg', '0.21.0'
gem 'pg_search'
gem "rack", ">= 2.0.8"
gem "rails-html-sanitizer", ">= 1.0.4"
gem 'ransack'
gem 'reform-rails'
gem 'rmagick'
gem 'russia_regions', '0.0.6'
gem 'russian'
gem 'sass-rails'
gem 'selectize-rails'
gem 'simple_form'
gem 'smart_buttons', '1.0.0.1'
gem 'state_machine', github: 'seuros/state_machine'
gem 'state_machine_buttons', '1.0'
gem 'time_difference'
gem 'trap', '3.0'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn-rails'
gem 'validates'

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.5'
  gem 'selenium-webdriver'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'redactor-rails', github: 'glyph-fr/redactor-rails'

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '5.1.1'
  gem 'faker'
  gem 'json_api_test_helpers', '1.2'
  gem 'json_matchers', github: 'BBonifield/json_matchers', branch: 'bugfix/properly-support-record-errors'
  gem 'rspec-json_expectations'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'webdrivers'
  gem 'webmock'
end

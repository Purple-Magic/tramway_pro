source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'tramway-sport_school', '1.2.3'
gem 'tramway-admin', '>= 1.2'
gem 'tramway-core', '>= 1.0.6'
gem 'tramway-landing', '1.2.7'
gem 'tramway-news', '>= 1.0.3'
gem 'tramway-profiles', '>= 1.1.1'
gem 'tramway-user', '>= 1.0.4'
gem 'tramway-conference', '1.0'
gem 'tramway-page', '1.1.3'

#gem 'tramway-page', path: '../tramway-dev/tramway-page'
#gem 'tramway-admin', path: '../tramway-dev/tramway-admin'
#gem 'tramway-core', path: '../tramway-dev/tramway-core'
#gem 'tramway-sport_school', path: '../tramway-dev/tramway-sport_school'
#gem 'tramway-landing', path: '../tramway-dev/tramway-landing'

ruby '2.5.1'

gem 'rails', '~> 5.1.4'
gem 'pg', '0.21.0'
gem 'unicorn'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails'
gem 'sass-rails'
gem 'bootstrap', '~> 4.1.0'
gem 'audited'
gem 'simple_form'
gem 'font-awesome-rails'
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
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

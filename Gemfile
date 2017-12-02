source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'unicorn'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
gem 'tramway-sport_school', github: 'kalashnikovisme/tramway-sport_school', branch: :develop
gem 'tramway-user', github: 'kalashnikovisme/tramway-user'
gem 'tramway-core', github: 'kalashnikovisme/tramway-core'
gem 'haml-rails'
gem 'sass-rails'
gem 'bootstrap', '~> 4.0.0.beta2.1'
gem 'audited'
gem 'simple_form'
gem 'font-awesome-rails'
gem 'coffee-rails'
gem 'jquery-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '0.21.0'
gem 'unicorn'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
#gem 'tramway-sport_school', github: 'ulmic/tramway-sport_school', branch: :develop
#gem 'tramway-user', github: 'ulmic/tramway-user', branch: :develop
#gem 'tramway-core', github: 'ulmic/tramway-core', branch: :develop
#gem 'tramway-admin', github: 'ulmic/tramway-admin', branch: :develop
#gem 'tramway-landing', github: 'ulmic/tramway-landing', branch: :develop
#gem 'tramway-news', github: 'ulmic/tramway-news', branch: :develop
#gem 'tramway-profiles', github: 'ulmic/tramway-profiles', branch: :develop
#
#
gem 'tramway-sport_school', '>= 1.1.2'
gem 'tramway-admin', '>= 1.1.1'
gem 'tramway-core', '>= 1.0.1'
gem 'tramway-landing', '>= 1.1'
gem 'tramway-news', '>= 1.0.2'
gem 'tramway-profiles', '>= 1.1'
gem 'tramway-user', '>= 1.0.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'bootstrap', '~> 4.0.0.beta2.1'
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
gem 'bootstrap-kaminari-views', github: 'rafaelmotta/bootstrap-kaminari-views', branch: :master
gem 'carrierwave'
gem 'mini_magick'
gem 'rmagick'
gem 'state_machine_buttons'
gem 'copyright_mafa'
gem 'more_html_tags', '>= 0.2.0'
gem 'ckeditor', github: 'galetahub/ckeditor'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry'
# gem 'tramway-sport_school', path: '../tramway-sport_school'
# gem 'tramway-admin', path: '../tramway-admin'
# gem 'tramway-core', path: '../tramway-core'
# gem 'tramway-user', path: '../tramway-user'
# gem 'tramway-landing', path: '../tramway-landing'
# gem 'tramway-profiles', path: '../tramway-profiles'
# gem 'tramway-news', path: '../tramway-news'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

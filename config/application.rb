require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TramwayPro
  class Application < Rails::Application
    config.load_defaults 5.1
    config.i18n.available_locales = [:en, :ru]
    config.i18n.default_locale = :ru
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
    config.autoload_paths += Dir[
      "#{config.root}/lib/**/"
    ]
  end
end

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
require_relative '../lib/middleware/multi_project_configuration_middleware/conference'
require_relative '../lib/middleware/multi_project_configuration_middleware/sport_school'
require_relative '../lib/middleware/multi_project_configuration_middleware/admin'
require_relative '../lib/middleware/multi_project_configuration_middleware/landing'

Bundler.require(*Rails.groups)

module TramwayPro
  class Application < Rails::Application
    config.load_defaults 5.1
    config.i18n.available_locales = [:en, :ru]
    #config.i18n.enforce_available_locales = false
    config.i18n.default_locale = :ru
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
    config.autoload_paths += Dir[ "#{config.root}/lib/**/" ]
    config.middleware.use ::MultiProjectConfigurationMiddleware::Conference
    config.middleware.use ::MultiProjectConfigurationMiddleware::SportSchool
    config.middleware.use ::MultiProjectConfigurationMiddleware::Admin
    config.middleware.use ::MultiProjectConfigurationMiddleware::Landing
  end
end

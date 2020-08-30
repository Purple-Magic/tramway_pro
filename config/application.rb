# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require_relative '../lib/middleware/multi_project_configuration_middleware/conference'
require_relative '../lib/middleware/multi_project_configuration_middleware/sport_school'
require_relative '../lib/middleware/multi_project_configuration_middleware/admin_middleware'
require_relative '../lib/middleware/multi_project_configuration_middleware/landing'
require_relative '../lib/middleware/multi_project_configuration_middleware/event'
require_relative '../lib/middleware/multi_project_configuration_middleware/partner'
require_relative '../lib/middleware/multi_project_configuration_middleware/user'
require_relative '../lib/middleware/multi_project_configuration_middleware/profiles'
require_relative '../lib/middleware/multi_project_configuration_middleware/page'
require_relative '../lib/middleware/multi_project_configuration_middleware/auth'
require_relative '../lib/middleware/multi_project_configuration_middleware/sites'
require_relative '../lib/middleware/multi_project_configuration_middleware/listai_book'
require_relative '../lib/middleware/multi_project_configuration_middleware/listai_page'

Bundler.require(*Rails.groups)

module TramwayPro
  class Application < Rails::Application
    config.load_defaults 5.1
    config.i18n.available_locales = [:ru]
    config.i18n.enforce_available_locales = false
    config.i18n.default_locale = :ru
    config.autoload_paths += ["#{config.root}/app/models/ckeditor"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.middleware.use ::MultiProjectConfigurationMiddleware::Conference
    config.middleware.use ::MultiProjectConfigurationMiddleware::SportSchool
    config.middleware.use ::MultiProjectConfigurationMiddleware::AdminMiddleware
    config.middleware.use ::MultiProjectConfigurationMiddleware::Landing
    config.middleware.use ::MultiProjectConfigurationMiddleware::Event
    config.middleware.use ::MultiProjectConfigurationMiddleware::User
    config.middleware.use ::MultiProjectConfigurationMiddleware::Profiles
    config.middleware.use ::MultiProjectConfigurationMiddleware::Page
    config.middleware.use ::MultiProjectConfigurationMiddleware::Partner
    config.middleware.use ::MultiProjectConfigurationMiddleware::Auth
    config.middleware.use ::MultiProjectConfigurationMiddleware::ListaiBook
    config.middleware.use ::MultiProjectConfigurationMiddleware::ListaiPage
    config.middleware.use ::Middleware::MultiProjectConfigurationMiddleware::Sites
  end
end

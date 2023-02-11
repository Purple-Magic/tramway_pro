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
require 'awesome_print'
require_relative '../lib/middleware/multi_project_configuration_middleware/auth'
require_relative '../lib/middleware/multi_project_configuration_middleware/conference'
require_relative '../lib/middleware/multi_project_configuration_middleware/admin_middleware'
require_relative '../lib/middleware/multi_project_configuration_middleware/landing'
require_relative '../lib/middleware/multi_project_configuration_middleware/event'
require_relative '../lib/middleware/multi_project_configuration_middleware/user'
require_relative '../lib/middleware/multi_project_configuration_middleware/profiles'
require_relative '../lib/middleware/multi_project_configuration_middleware/page'
require_relative '../lib/middleware/multi_project_configuration_middleware/partner'
require_relative '../lib/middleware/multi_project_configuration_middleware/listai_book'
require_relative '../lib/middleware/multi_project_configuration_middleware/listai_page'
require_relative '../lib/middleware/multi_project_configuration_middleware/podcasts'
require_relative '../lib/middleware/multi_project_configuration_middleware/purple_magic_callback'
require_relative '../lib/middleware/multi_project_configuration_middleware/bot_middleware'

Bundler.require(*Rails.groups)

module TramwayPro
  class Application < Rails::Application
    config.load_defaults 7.0

    config.i18n.available_locales = [:ru]
    config.i18n.enforce_available_locales = false
    config.i18n.default_locale = :ru
    config.autoload_paths << "#{config.root}/app/models/ckeditor"
    config.autoload_paths << "#{config.root}/app/services"
    config.autoload_paths << "#{config.root}/lib"
    config.eager_load_paths << "#{config.root}/lib"

    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Auth
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Conference
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::AdminMiddleware
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Landing
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Event
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::User
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Profiles
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Page
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Partner
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::ListaiBook
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::ListaiPage
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::Podcasts
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::PurpleMagicCallback
    config.middleware.use Middleware::MultiProjectConfigurationMiddleware::BotMiddleware

    config.active_job.queue_adapter = :sidekiq

    config.active_record.yaml_column_permitted_classes = [
      ActiveSupport::TimeWithZone,
      Time,
      ActiveSupport::TimeZone
    ]
  end
end

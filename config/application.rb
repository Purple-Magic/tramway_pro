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
require_relative '../lib/middleware/multi_project_configuration_middleware/conference'
require_relative '../lib/middleware/multi_project_configuration_middleware/admin_middleware'
require_relative '../lib/middleware/multi_project_configuration_middleware/api_middleware'
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
require_relative '../lib/middleware/multi_project_configuration_middleware/news'

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
    config.middleware.use ::MultiProjectConfigurationMiddleware::AdminMiddleware
    config.middleware.use ::MultiProjectConfigurationMiddleware::ApiMiddleware
    config.middleware.use ::MultiProjectConfigurationMiddleware::Landing
    config.middleware.use ::MultiProjectConfigurationMiddleware::Event
    config.middleware.use ::MultiProjectConfigurationMiddleware::User
    config.middleware.use ::MultiProjectConfigurationMiddleware::Profiles
    config.middleware.use ::MultiProjectConfigurationMiddleware::Page
    config.middleware.use ::MultiProjectConfigurationMiddleware::Partner
    config.middleware.use ::MultiProjectConfigurationMiddleware::ListaiBook
    config.middleware.use ::MultiProjectConfigurationMiddleware::ListaiPage
    config.middleware.use ::MultiProjectConfigurationMiddleware::Podcasts
    config.middleware.use ::MultiProjectConfigurationMiddleware::PurpleMagicCallback
    config.middleware.use ::MultiProjectConfigurationMiddleware::BotMiddleware
    config.middleware.use ::MultiProjectConfigurationMiddleware::News
    config.active_job.queue_adapter = :sidekiq
  end
end

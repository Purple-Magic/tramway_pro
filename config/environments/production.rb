# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.read_encrypted_secrets = true
  config.public_file_server.enabled = true
  config.assets.configure do |env|
    env.js_compressor  = :uglifier # or :closure, :yui
    env.css_compressor = :sass   # or :yui
  end
  config.assets.compile = true
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false

  config.hosts += [
    "red-magic.pro",
    "it-way.pro",
    "kalashnikovisme.ru",
    "benchkiller.com",
    "purple-magic.com",
    "engineervol.ru"
  ]
end

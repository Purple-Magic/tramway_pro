# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.logger = Logger.new('./log/sidekiq.log')
  config.logger.level = ::Logger::INFO
  Sidekiq::Cron::Job.load_from_hash YAML.load_file 'config/sidekiq-schedule.yml'
end

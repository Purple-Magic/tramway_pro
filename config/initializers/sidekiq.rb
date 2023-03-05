# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.logger = Logger.new('./log/sidekiq.log')
  config.logger.level = ::Logger::INFO
  Sidekiq::Cron::Job.load_from_hash YAML.load_file 'config/sidekiq-schedule.yml'

  config.redis = {
    url: 'redis://localhost:6379/0',
    namespace: 'tramway',
    network_timeout: 20
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6379/0',
    network_timeout: 20
  }
end

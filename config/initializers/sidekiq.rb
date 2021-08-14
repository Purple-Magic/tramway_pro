Sidekiq.configure_server do |config|
  config.logger = Logger.new('./log/sidekiq.log')
  config.logger.level = ::Logger::INFO
end

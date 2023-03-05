# frozen_string_literal: true

class ApplicationWorker
  include Sidekiq::Worker
  include ExtendedLogger
  include Podcasts
end

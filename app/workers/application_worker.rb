# frozen_string_literal: true

class ApplicationWorker
  include Sidekiq::Worker
  include ExtendedLogger
end

# frozen_string_literal: true

if Rails.env.production?
  Airbrake.configure do |config|
    config.host = 'http://errors.tramway.pro:8079'
    config.project_id = 1
    config.project_key = ENV['ERRBIT_PROJECT_KEY'] || '123'
    config.ignore_environments = %w(development test)
  end
end

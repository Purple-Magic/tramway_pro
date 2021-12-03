# frozen_string_literal: true

unless Rails.env.test?
  Airbrake.configure do |config|
    config.host = 'http://errors.tramway.pro:8079'
    config.project_id = 1
    config.project_key = ENV['ERRBIT_PROJECT_KEY'] || '123'
  end
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'pry'
require 'capybara/rspec'
require_relative 'web_driver_helper'
require 'fileutils'
require_relative 'support/integration_helpers'

RSpec.configure do |config|
  config.include IntegrationHelpers

  config.after(:each) do |test|
    if ENV['UPDATE_RESULT'] == 'true'
      stage = if test.metadata[:example_group][:parent_example_group][:description] == 'Default clusterization spec'
                :stage1
              end
      state = test.metadata[:example_group][:description].downcase
      test_name = test.metadata[:description].gsub(' ', '_').downcase
      FileUtils.cp('./tmp/files/result.xlsx', "./files/#{stage}/#{state}/#{test_name}/result.xlsx")
      puts "#{test.metadata[:full_description]} result updated"
    end
    unless ENV['SAVE_RESULT'] == 'true'
      FileUtils.rm_f(Dir["./tmp/files/*"])
      FileUtils.rm_f(Dir["./capybara-*.html"])
      FileUtils.rm_f(Dir["../capybara-*.html"])
    end
  end
end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = ENV['APP_HOST']
end

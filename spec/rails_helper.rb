require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'factory_bot'
require 'rspec/rails'
require 'rspec/json_expectations'
require 'json_matchers/rspec'
require 'support/auth_helper'
require 'support/json_api_helpers'
require 'rake'
require 'webmock/rspec'
WebMock.disable_net_connect! allow_localhost: true
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.include RSpec::Rails::RequestExampleGroup, type: :feature
  config.include AuthHelper
  config.include JsonApiHelpers

  ActiveRecord::Base.logger.level = 1
end

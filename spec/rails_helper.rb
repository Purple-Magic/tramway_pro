require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'factory_bot'
require 'rspec/rails'
require 'rspec/json_expectations'
require 'json_matchers/rspec'
require 'support/projects_helper'
require 'support/integration_helpers'
require 'json_api_test_helpers'
require 'rake'
require 'webmock/rspec'
require 'database_cleaner'
WebMock.disable_net_connect! allow_localhost: true
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.include RSpec::Rails::RequestExampleGroup, type: :feature
  config.include JsonApiTestHelpers
  config.include WebMock::API
  config.include ::Tramway::Core::Concerns::AttributesDecoratorHelper
  config.include ProjectsHelper
  config.include IntegrationHelpers

  ActiveRecord::Base.logger.level = 1

  ['it-way.test', 'sportschool-ulsk.test'].each do |url|
    next if Project.where(url: url).any?
    Project.create! url: url
  end
  config.before(:all) do
    ActiveRecord::Base.descendants.each do |model|
      next if model.to_s.in? ['PgSearch::Document', 'Project']
      next if model.abstract_class

      model.delete_all
    end
    FactoryBot.create :admin, email: 'admin@email.com', password: '123456', role: :admin
  end
  include ActionDispatch::TestProcess
end

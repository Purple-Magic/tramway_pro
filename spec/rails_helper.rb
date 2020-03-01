# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'
require 'support/projects_helper'
require 'support/integration_helpers'
require 'support/errors_helper'
require 'support/navbar_helper'
require 'json_api_test_helpers'
#require 'web_driver_helper'
require 'rake'
require 'webmock/rspec'
WebMock.disable_net_connect! allow_localhost: true

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
  config.include ErrorsHelper
  config.include NavbarHelper

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
    create :admin, email: 'admin@email.com', password: '123456', role: :admin
    create :unity, title: 'IT Way'
  end
  include ActionDispatch::TestProcess
end

# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'
require 'support/projects_helper'
require 'support/integration_helpers'
require 'support/errors_helper'
require 'support/navbar_helper'
require 'support/tramway_helpers'
require 'support/capybara_helpers'
require 'json_api_test_helpers'
# require 'web_driver_helper'
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
  config.include TramwayHelpers
  config.include CapybaraHelpers

  ActiveRecord::Base.logger.level = 1

  ['it-way.test', 'sportschool-ulsk.test', 'tramway.test'].each do |url|
    next if Project.where(url: url).any?

    Project.create! url: url
  end
  config.before(:all) do
    ActiveRecord::Base.descendants.each do |model|
      next if model.to_s.in? ['PgSearch::Document', 'Project']
      next if model.abstract_class

      model.delete_all
    end
    ProjectsHelper.projects.each do |project| 
      if Tramway::User::User.find_by(email: "admin@email.com", project_id: project.id).nil?
        user = Tramway::User::User.create(email: "admin@email.com", role: :admin, project_id: project.id)
        user.password = '123456'
        user.save!
      end
    end
    create :unity, title: 'IT Way'
    create :institution, title: 'Sport school ULSK'
    create :tramway_dev, name: 'Tramway'
  end
  include ActionDispatch::TestProcess
end

# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'
require 'capybara_helpers'
require 'support/projects_helper'
require 'support/integration_helpers'
require 'support/errors_helper'
require 'support/navbar_helper'
require 'support/tramway_helpers'
require 'json_api_test_helpers'
require 'rake'
require 'webmock/rspec'
require 'telegram/bot'
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

  Settings[:test].each do |pair|
    next if pair[0].in? %i[engines application_class application]

    title = pair[0].to_s.camelize
    url = pair[1]
    next if Project.where(url: url, title: title).any?

    Project.create! url: url, title: title
  end
  config.before(:all) do
    ActiveRecord::Base.descendants.each do |model|
      next if model.to_s.in? ['PgSearch::Document', 'Project']
      next if model.abstract_class

      model.delete_all
      ActiveRecord::Base.connection.execute('DELETE FROM tramway_user_users')
    end
    ProjectsHelper.projects.each do |project|
      create :admin, email: "admin#{project.id}@email.com", password: '123456', role: :admin, project_id: project.id
    end
    create :unity, title: 'IT Way'
    create :tramway_dev, name: :tramway, title: 'Tramway'
    create :purple_magic, name: :purple_magic, title: 'Purple Magic'
    create :red_magic, name: :red_magic, title: 'Red Magic'
  end
  include ActionDispatch::TestProcess
end

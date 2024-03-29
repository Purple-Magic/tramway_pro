# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'
require 'capybara_helpers'
require 'json_api_test_helpers'
require 'rake'
require 'webmock/rspec'
require 'web_driver_helper'
require 'telegram/bot'
require "#{Rails.root}/lib/benchkiller/regions_concern.rb"

require 'support/projects_helper'
require 'support/integration_helpers'
require 'support/errors_helper'
require 'support/navbar_helper'
require 'support/tramway_helpers'
require 'support/telegram_bot_helpers'
require 'support/benchkiller_helpers'
require 'support/asserting_models'
require 'support/filling_forms'
require 'support/long_test_staff'
require 'support/airtable_helpers'
require 'support/bot_run_helper'

WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: 'chromedriver.storage.googleapis.com'
)

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.include RSpec::Rails::RequestExampleGroup, type: :feature
  config.include JsonApiTestHelpers
  config.include WebMock::API
  config.include Tramway::Concerns::AttributesDecoratorHelper
  config.include ProjectsHelper
  config.include IntegrationHelpers
  config.include ErrorsHelper
  config.include NavbarHelper
  config.include TramwayHelpers
  config.include CapybaraHelpers
  config.include TelegramBotHelpers
  config.include BenchkillerHelpers
  config.include AssertingModels
  config.include FillingForms
  config.include LongTestStuff
  config.include Benchkiller::RegionsConcern
  config.include AirtableHelpers
  config.include BotRunHelper

  ActiveRecord::Base.logger.level = 1

  Project.delete_all
  Settings[:test].each do |pair|
    next if pair[0].in? %i[engines application_class application]

    title = pair[0].to_s.camelize
    url = pair[1]

    Project.find_or_create_by! url: url, title: title
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

module Kernel
  def system(cmd)
    Rails.logger.info cmd
  end
end

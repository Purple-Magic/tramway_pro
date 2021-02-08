# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class BotMiddleware
    def initialize(app)
      @app = app
    end

    PAIRS = {
      'BotTelegram::Scenario::ProgressRecord' => 'MultiProjectCallbacks::BotTelegram::Scenario::ProgressRecordConcern',
      'BotTelegram::Scenario::Step' => 'MultiProjectCallbacks::BotTelegram::Scenario::StepConcern'
    }.freeze

    FORMS = ['BotTelegram::Scenario::ProgressRecordForm', 'BotTelegram::Scenario::StepForm'].freeze

    def call(env)
      PAIRS.each do |pair|
        pair.first.constantize.include pair.last.constantize
      end

      FORMS.each do |name|
        "Admin::#{name}".constantize.include "MultiProjectCallbacks::#{name}".constantize
      end

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module BotTelegram
    module Scenario
      module ProgressRecordForm
        extend ActiveSupport::Concern

        included do
          properties :project_id
        end
      end

      module ProgressRecordConcern
        extend ActiveSupport::Concern

        included do
          default_scope do
            where project_id: Project.where(url: ENV['PROJECT_URL'])
          end
        end
      end

      module StepForm
        extend ActiveSupport::Concern

        included do
          properties :project_id
        end
      end

      module StepConcern
        extend ActiveSupport::Concern

        included do
          default_scope do
            where project_id: Project.where(url: ENV['PROJECT_URL'])
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class BotMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      ::BotTelegram::Scenario::ProgressRecord.include MultiProjectCallbacks::BotTelegram::Scenario::ProgressRecordConcern
      ::Admin::BotTelegram::Scenario::ProgressRecordForm.include MultiProjectCallbacks::BotTelegram::Scenario::ProgressRecordForm
      ::BotTelegram::Scenario::Step.include MultiProjectCallbacks::BotTelegram::Scenario::StepConcern
      ::Admin::BotTelegram::Scenario::StepForm.include MultiProjectCallbacks::BotTelegram::Scenario::StepForm

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

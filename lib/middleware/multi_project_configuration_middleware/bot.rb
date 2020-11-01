# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Bot
    def initialize(app)
      @app = app
    end

    def call(env)
      ::BotTelegram::Scenario::ProgressRecord.include MultiProjectCallbacks::BotTelegram::Scenario::ProgressRecordConcern
      ::BotTelegram::Scenario::ProgressRecordForm.include MultiProjectCallbacks::BotTelegram::Scenario::ProgressRecordForm

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
    end
  end
end

# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class PurpleMagicCallback
    def initialize(app)
      @app = app
    end

    def call(env)
      ::PurpleMagic.include MultiProjectCallbacks::PurpleMagicConcern
      ::Admin::PurpleMagicForm.include MultiProjectCallbacks::PurpleMagicForm

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module PurpleMagicForm
    extend ActiveSupport::Concern

    included do
      properties :project_id
    end
  end

  module PurpleMagicConcern
    extend ActiveSupport::Concern

    included do
      default_scope do
        where project_id: Project.where(url: ENV['PROJECT_URL'])
      end
    end
  end
end

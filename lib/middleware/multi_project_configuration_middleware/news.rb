# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class News
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Tramway::News::NewsForm.include MultiProjectCallbacks::News::NewsForm
      ::Tramway::News::News.include MultiProjectCallbacks::News::NewsConcern
      ::Tramway::News::NewsController.include MultiProjectCallbacks::News::NewsController

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module News
    module NewsForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module NewsConcern
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL'])
        end
      end
    end

    module NewsController
      extend ActiveSupport::Concern

      included do
        before_action :load_application

        def load_application
          engine_loaded = Constraints::DomainConstraint.new(request.domain).engine_loaded
          if engine_loaded.present?
            engine_module = "::Tramway::#{engine_loaded.camelize}".constantize
            @application = "#{engine_module}::#{engine_module.application.to_s.camelize}".constantize.first
            @application_engine = engine_loaded
          else
            @application
          end
        end
      end
    end
  end
end

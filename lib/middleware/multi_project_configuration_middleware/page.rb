# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Page
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Tramway::Page::PageForm.include MultiProjectCallbacks::Page::PageForm
      ::Tramway::Page::Page.include MultiProjectCallbacks::Page::PageConcern
      ::Tramway::Page::PagesController.include MultiProjectCallbacks::Page::PagesController

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Page
    module PageForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module PageConcern
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL'])
        end
      end
    end

    module PagesController
      extend ActiveSupport::Concern

      included do
        before_action :load_application

        def load_application
          engine_loaded = Constraints::DomainConstraint.new(request.domain).engine_loaded
          engine_module = "::Tramway::#{engine_loaded.camelize}".constantize
          @application = "#{engine_module}::#{engine_module.application.to_s.camelize}".constantize.first
          @application_engine = engine_loaded
        end
      end
    end
  end
end

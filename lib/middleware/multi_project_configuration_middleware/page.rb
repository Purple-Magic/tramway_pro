# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Page
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Tramway::Page::PageForm.include MultiProjectCallbacks::Page::PageForm
      ::Tramway::Page::Page.include MultiProjectCallbacks::Page::PageConcern

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
  end
end

# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Page
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Page::PageForm.include MultiProjectCallbacks::Page::PageForm

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
  end
end

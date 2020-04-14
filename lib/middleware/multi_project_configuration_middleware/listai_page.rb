# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class ListaiPage
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Listai::PageForm.include MultiProjectCallbacks::ListaiPage::PageForm
      ::Listai::Page.include MultiProjectCallbacks::ListaiPage::PageConcern

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module ListaiPage
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

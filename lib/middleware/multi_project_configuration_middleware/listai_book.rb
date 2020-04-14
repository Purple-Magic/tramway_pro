# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class ListaiBook 
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Listai::BookForm.include MultiProjectCallbacks::ListaiBook::BookForm
      ::Listai::Book.include MultiProjectCallbacks::ListaiBook::BookConcern

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module ListaiBook
    module BookForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module BookConcern
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL'])
        end
      end
    end
  end
end

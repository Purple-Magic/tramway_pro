module MultiProjectConfigurationMiddleware 
  class User
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::User::UserForm.include MultiProjectCallbacks::User::UserForm
      ::Tramway::User::ApplicationController.include MultiProjectCallbacks::User::Application

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module User
    module UserForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module Application
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

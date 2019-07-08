require_relative '../multi_project_callbacks/sites'

module Middleware
  module MultiProjectConfigurationMiddleware 
    class Sites
      def initialize(app)
        @app = app
      end

      def call(env)
        ::Tramway::Site::Web::WelcomeController.include ::MultiProjectCallbacks::Sites

        @app.call(env)
      end
    end
  end
end

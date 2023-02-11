# frozen_string_literal: true

module Middleware
  module MultiProjectConfigurationMiddleware
    class Auth
      def initialize(app)
        @app = app
      end

      def call(env)
        Tramway::ApplicationController.include MultiProjectCallbacks::Auth::Application

        @app.call(env)
      end
    end
  end
end

module MultiProjectCallbacks
  module Auth
    module Application
      extend ActiveSupport::Concern

      included do
        before_action :load_application

        def load_application
          if engine_loaded(request).present?
            build_application_with_engine engine_loaded request
          elsif application_class(request).present?
            @application = application_class(request).camelize.constantize.first
          else
            @application = application_object request
          end
        end

        private

        def build_application_with_engine(engine_loaded)
          engine_module = "::Tramway::#{engine_loaded.camelize}".constantize
          @application = "#{engine_module}::#{engine_module.application.to_s.camelize}".constantize.first
          @application_engine = engine_loaded
        end

        def application_class(request)
          Constraints::DomainConstraint.new(request.domain).application_class
        end

        def engine_loaded(request)
          Constraints::DomainConstraint.new(request.domain).engine_loaded
        end

        def application_object(request)
          Constraints::DomainConstraint.new(request.domain).application_object
        end
      end
    end
  end
end

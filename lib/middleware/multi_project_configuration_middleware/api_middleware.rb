# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class ApiMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Api::V1::ApplicationController.include MultiProjectCallbacks::ApiMiddleware::Application
      ::Tramway::Api::V1::RecordsController.include MultiProjectCallbacks::ApiMiddleware::Records

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module ApiMiddleware
    module Records
      extend ActiveSupport::Concern

      included do
        actions = [:index]
        actions.each do |action|
          before_render "after_#{action}".to_sym, only: action
        end

        def after_index
          project = Project.where(url: ENV['PROJECT_URL']).first
          unless params[:model] == 'Project'
            @records = decorator_class.decorate @records.original_array.where project_id: project.id
          end
          @counts = build_counts project
        end

        before_action :add_project_id, only: %i[create update]

        def add_project_id
          return if params[:model] == 'Project'

          binding.pry
          if params[:record].present?
            params[:record][:project_id] = Project.where(url: ENV['PROJECT_URL']).first.id
          else
            params[:singleton][:project_id] = Project.where(url: ENV['PROJECT_URL']).first.id
          end
        end
      end
    end

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

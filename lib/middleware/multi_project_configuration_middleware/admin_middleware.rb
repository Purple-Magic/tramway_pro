# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class AdminMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Admin::ApplicationController.include MultiProjectCallbacks::AdminMiddleware::Application
      ::Tramway::Admin::RecordsController.include MultiProjectCallbacks::AdminMiddleware::Records

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module AdminMiddleware
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
          params[:record][:project_id] = Project.where(url: ENV['PROJECT_URL']).first.id
        end

        private

        def build_counts(project)
          decorator_class.collections.reduce({}) do |hash, collection|
            array = model_class.active.send(collection)
            array = array.where(project_id: project.id) unless params[:model] == 'Project'
            array = array.ransack(params[:filter]).result if params[:filter].present?
            hash.merge! collection => array.count
          end
        end
      end
    end

    module Application
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
            @application = Constraints::DomainConstraint.new(request.domain).application_class.camelize.constantize.first 
          end
        end
      end
    end
  end
end

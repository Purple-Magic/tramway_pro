module MultiProjectConfigurationMiddleware 
  class Admin
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Admin::RecordsController.include MultiProjectCallbacks::Admin

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Admin
    extend ActiveSupport::Concern

    included do
      actions = [ :index ]
      actions.each do |action|
        before_render "after_#{action}".to_sym, only: action
      end

      before_action :load_application

      def load_application
        binding.pry
        engine_loaded = Constraints::DomainConstraint.new(request.domain).engine_loaded
        engine_module = "::Tramway::#{engine_loaded.camelize}".constantize
        @application = "#{engine_module}::#{engine_module.application.to_s.camelize}".constantize.first
        @application_engine = engine_loaded
      end

      def after_index
        project = Project.where(url: ENV['PROJECT_URL']).first
        @records = decorator_class.decorate @records.original_array.where project_id: project.id
      end
    end
  end
end

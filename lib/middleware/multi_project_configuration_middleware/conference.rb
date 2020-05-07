# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Conference
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Conference::Web::WelcomeController.include MultiProjectCallbacks::Conference

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Conference
    extend ActiveSupport::Concern

    included do
      actions = [:index]
      actions.each do |action|
        before_render "after_#{action}".to_sym, only: action
      end

      before_action :load_application

      def after_index
        project = Project.where(url: ENV['PROJECT_URL']).first
        @blocks = ::Tramway::Landing::BlockDecorator.decorate @blocks.original_array.where(project_id: project.id)
        @links = build_links @links, project
      end

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

      def build_links(links, project)
        links.reduce([]) do |array, link|
          array ||= []
          if link.is_a? Hash
            array << { link.keys.first => link.values.first.select { |obj| obj.model.project_id == project.id } }
          elsif link.model.project_id == project.id
            array << link
          end
        end
      end
    end
  end
end

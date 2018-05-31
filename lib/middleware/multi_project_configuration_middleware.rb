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
      actions = [ :index ]
      actions.each do |action|
        before_render "after_#{action}".to_sym, only: action
      end


      def after_index
        project = Project.where(url: ENV['PROJECT_URL']).first
        @blocks = @blocks.where(project_id: project.id)
      end
    end
  end
end

module MultiProjectConfigurationMiddleware 
  class Event
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Event::EventForm.include MultiProjectCallbacks::Event::EventForm

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Event
    module EventForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end
  end
end

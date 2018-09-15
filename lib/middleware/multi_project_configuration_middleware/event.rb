module MultiProjectConfigurationMiddleware 
  class Event
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Event::EventForm.include MultiProjectCallbacks::Event::EventForm
      ::Tramway::Event::ParticipantForm.include MultiProjectCallbacks::Event::ParticipantForm
      ::Tramway::Event::ParticipantFormFieldForm.include MultiProjectCallbacks::Event::ParticipantFormFieldForm
      ::Tramway::Event::ParticipantFormField.include MultiProjectCallbacks::Event::EventModel

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

    module ParticipantFormFieldForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module ParticipantForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module EventModel
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL']).first.id
        end
      end
    end
  end
end

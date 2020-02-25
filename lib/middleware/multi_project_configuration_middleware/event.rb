# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Event
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Tramway::Event::EventForm.include MultiProjectCallbacks::Event::EventForm
      ::Admin::Tramway::Event::ParticipantForm.include MultiProjectCallbacks::Event::ParticipantForm
      ::Admin::Tramway::Event::ParticipantFormFieldForm.include MultiProjectCallbacks::Event::ParticipantFormFieldForm
      ::Admin::Tramway::Event::SectionForm.include MultiProjectCallbacks::Event::SectionForm
      ::Admin::Tramway::Event::PartakingForm.include MultiProjectCallbacks::Event::PartakingForm
      ::Admin::Tramway::Event::PersonForm.include MultiProjectCallbacks::Event::PersonForm

      ::Tramway::Event::ParticipantFormField.include MultiProjectCallbacks::Event::EventModel

      ::Tramway::Event::ParticipantsController.include MultiProjectCallbacks::Event::ParticipantsController
      ::Tramway::Event::EventsController.include MultiProjectCallbacks::Event::EventsController
      #      ::Tramway::Event::PlaceForm.include MultiProjectCallbacks::Event::PlaceForm

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

    module PartakingForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module PlaceForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module PersonForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module SectionForm
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

    module ParticipantsController
      extend ActiveSupport::Concern

      included do
        after_action :add_project_id, only: [:create]

        def add_project_id
          if @participant_form.model.id.present?
            @participant_form.model.update project_id: Project.where(url: ENV['PROJECT_URL']).first.id
          end
        end
      end
    end

    module EventsController
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

# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Event
    def initialize(app)
      @app = app
    end

    PAIRS = {
      '::Admin::Tramway::Event::EventForm' => 'MultiProjectCallbacks::Event::EventForm',
      '::Admin::Tramway::Event::ParticipantForm' => 'MultiProjectCallbacks::Event::ParticipantForm',
      '::Admin::Tramway::Event::ParticipantFormFieldForm' => 'MultiProjectCallbacks::Event::ParticipantFormFieldForm',
      '::Admin::Tramway::Event::SectionForm' => 'MultiProjectCallbacks::Event::SectionForm',
      '::Admin::Tramway::Event::PartakingForm' => 'MultiProjectCallbacks::Event::PartakingForm',
      '::Admin::Tramway::Event::PersonForm' => 'MultiProjectCallbacks::Event::PersonForm',
      '::Admin::Tramway::Event::ActionForm' => 'MultiProjectCallbacks::Event::ActionForm',
      'Tramway::Event::Event' => 'Tramway::Event::EventConcern',
      '::Tramway::Event::Participant' => 'MultiProjectCallbacks::Event::ParticipantConcern',
      '::Tramway::Event::ParticipantsController' => 'MultiProjectCallbacks::Event::ParticipantsController',
      '::Tramway::Event::EventsController' => 'MultiProjectCallbacks::Event::EventsController'
    }.freeze

    def call(env)
      PAIRS.each do |pair|
        pair.first.constantize.include pair.last.constantize
      end

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

    module ActionForm
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

    module ParticipantsController
      extend ActiveSupport::Concern

      included do
        after_action :add_project_id, only: [:create]

        def add_project_id
          return unless @participant_form.model.id.present?

          @participant_form.model.update project_id: Project.where(url: ENV['PROJECT_URL']).first.id
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

    module ParticipantConcern
      extend ActiveSupport::Concern
      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL'])
        end

        scope :partner_scope, ->(_user_id) { all }
        %i[rsm night podcast slurm skillbox benchkiller hexlet].each do |team|
          scope "#{team}_scope".to_sym, ->(_user_id) { all }
        end
      end
    end
  end
end

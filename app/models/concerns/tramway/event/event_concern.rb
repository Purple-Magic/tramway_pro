# frozen_string_literal: true

module Tramway::Event::EventConcern
  extend ActiveSupport::Concern

  included do
    scope :partner_scope, ->(partner_id) { created_by_user partner_id }

    MANDATORY_FIELDS = YAML.load_file(Rails.root.join('lib', 'yaml', 'mandatory_fields.yml')).with_indifferent_access
    MANDATORY_ACTIONS = YAML.load_file(Rails.root.join('lib', 'yaml', 'mandatory_actions.yml')).with_indifferent_access

    after_create do
      MANDATORY_FIELDS.each do |field|
        Tramway::Event::ParticipantFormField.create! field[1].merge event_id: id
      end
      MANDATORY_ACTIONS.each do |action|
        deadline = action[1][:deadline][:days].send(:days).send(action[1][:deadline][:when], begin_date)
        Tramway::Event::Action.create! title: action[1][:title], deadline: deadline, event_id: id
      end
    end
  end
end

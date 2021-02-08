# frozen_string_literal: true

module Tramway::Event::EventConcern
  extend ActiveSupport::Concern

  included do
    mandatory_fields = YAML.load_file(Rails.root.join('lib', 'yaml', 'mandatory_fields.yml')).with_indifferent_access
    mandatory_actions = YAML.load_file(Rails.root.join('lib', 'yaml', 'mandatory_actions.yml')).with_indifferent_access

    after_create do
      mandatory_fields.each do |field|
        Tramway::Event::ParticipantFormField.create! field[1].merge event_id: id
      end
      mandatory_actions.each do |action|
        deadline = action[1][:deadline][:days].send(:days).send(action[1][:deadline][:when], begin_date)
        Tramway::Event::Action.create! title: action[1][:title], deadline: deadline, event_id: id
      end
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :action_admin_attributes, class: 'Tramway::Event::Action' do
    title
    event_id { Tramway::Event::Event.last&.id || create(:event).id }
    deadline { generate :date }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :participant_form_field_admin_attributes, class: 'Tramway::Event::ParticipantFormField' do
    title { generate :string }
    description { generate :string }
    field_type { Tramway::Event::ParticipantFormField.field_type.values.sample.text }
    list_field { [true, false].sample }
    position { generate :integer }
  end
end

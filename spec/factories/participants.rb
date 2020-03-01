# frozen_string_literal: true

FactoryBot.define do
  factory :participant, class: 'Tramway::Event::Participant' do
    values do
      {
        'Фамилия' => generate(:string),
        'Имя' => generate(:string),
        'Место учёбы / работы' => generate(:string),
        'Email' => generate(:email),
        'Номер телефона' => generate(:phone),
      }
    end
    event_id { Tramway::Event::Event.last&.id || create(:event).id }
  end

  factory :participant_default_event_attributes, class: 'Tramway::Event::Participant' do
    send('Фамилия') { generate(:string) }
    send('Имя') { generate(:string) }
    send('Место учёбы / работы') { generate(:string) }
    send('Email') { generate(:email) }
    send('Номер телефона') { generate(:phone) }
  end

  factory :participant_admin_attributes, parent: :participant_default_event_attributes
end

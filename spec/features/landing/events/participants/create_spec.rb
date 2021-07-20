# frozen_string_literal: true

require 'rails_helper'

describe 'IT Way: Creating participant' do
  let!(:event) { create :event, :created_by_full_filled_admin, :campaign_started }
  let(:attributes) { attributes_for :participant_default_event_attributes }

  before do
    move_host_to it_way_host
  end

  it 'should create participant' do
    count = Tramway::Event::Participant.count
    visit "/events/#{event.id}"

    fill_in 'tramway_event_participant[Фамилия]', with: attributes[:Фамилия]
    fill_in 'tramway_event_participant[Имя]', with: attributes[:Имя]
    fill_in 'tramway_event_participant[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
    fill_in 'tramway_event_participant[Номер телефона]', with: attributes[:'Номер телефона']
    fill_in 'tramway_event_participant[Email]', with: attributes[:Email]

    click_on 'Отправить заявку'

    expect(Tramway::Event::Participant.count).to eq count + 1
  end

  it 'should create participant and show events page' do
    visit "/events/#{event.id}"

    fill_in 'tramway_event_participant[Фамилия]', with: attributes[:Фамилия]
    fill_in 'tramway_event_participant[Имя]', with: attributes[:Имя]
    fill_in 'tramway_event_participant[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
    fill_in 'tramway_event_participant[Номер телефона]', with: attributes[:'Номер телефона']
    fill_in 'tramway_event_participant[Email]', with: attributes[:Email]

    click_on 'Отправить заявку'

    expect(page).to have_content 'Заявка отправлена успешно!'
  end

  it 'should create participant with needed arguments' do
    visit "/events/#{event.id}"

    fill_in 'tramway_event_participant[Фамилия]', with: attributes[:Фамилия]
    fill_in 'tramway_event_participant[Имя]', with: attributes[:Имя]
    fill_in 'tramway_event_participant[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
    fill_in 'tramway_event_participant[Номер телефона]', with: attributes[:'Номер телефона']
    fill_in 'tramway_event_participant[Email]', with: attributes[:Email]

    click_on 'Отправить заявку'

    participant = Tramway::Event::Participant.last

    attributes.each do |pair|
      actual = participant.values[pair[0].to_s]
      expecting = pair[1]
      expecting = expecting.strftime('%d.%m.%Y') if expecting.is_a? DateTime
      expect(actual).to eq(expecting), problem_with(attr: pair[0], expecting: expecting, actual: actual)
    end
  end

  context 'Organizer info checking' do
    let(:event) { create :event, :campaign_started, :created_by_admin }

    it 'should show event creator data' do
      visit "/events/#{event.id}"

      fill_in 'tramway_event_participant[Фамилия]', with: attributes[:Фамилия]
      fill_in 'tramway_event_participant[Имя]', with: attributes[:Имя]
      fill_in 'tramway_event_participant[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
      fill_in 'tramway_event_participant[Номер телефона]', with: attributes[:'Номер телефона']
      fill_in 'tramway_event_participant[Email]', with: attributes[:Email]

      click_on 'Отправить заявку'

      expect(page).to have_content event.creator&.phone
      expect(page).to have_content event.creator&.email
    end
  end
end

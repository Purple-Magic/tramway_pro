# frozen_string_literal: true

require 'rails_helper'

describe 'IT Way: Creating participant' do
  before { move_host_to it_way_host }
  let(:event) { create :event, :campaign_started, project_id: it_way_id }
  let(:attributes) { attributes_for :participant_default_event_attributes }

  context 'Error' do
    it 'saving participant data in the form' do
      visit "/events/#{event.id}"

      fill_in 'tramway_event_participant[Имя]', with: attributes[:'Имя']
      fill_in 'tramway_event_participant[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
      fill_in 'tramway_event_participant[Номер телефона]', with: attributes[:'Номер телефона']
      fill_in 'tramway_event_participant[Email]', with: attributes[:Email]

      click_on 'Отправить заявку'

      expect(page).to have_field('tramway_event_participant[Имя]', with: attributes[:'Имя'])
      expect(page).to(
        have_field('tramway_event_participant[Место учёбы / работы]', with: attributes[:'Место учёбы / работы'])
      )
      expect(page).to have_field('tramway_event_participant[Номер телефона]', with: attributes[:'Номер телефона'])
      expect(page).to have_field('tramway_event_participant[Email]', with: attributes[:Email])
    end
  end
end

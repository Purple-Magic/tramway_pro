# frozen_string_literal: true

require 'rails_helper'

describe 'IT Way: Show event' do
  before { move_host_to it_way_host }

  context 'Collecting requests campaign started' do
    let(:event) { create :event, :campaign_started }

    it 'should show event' do
      visit "/events/#{event.id}"

      expect(page).to have_content event.title
    end

    it 'should show participants form' do
      visit "/events/#{event.id}"

      event.participant_form_fields.each do |form_field|
        expect(page).to have_field "tramway_event_participant[#{form_field.title}]"
      end
    end

    context 'without mandatory fields' do
      it 'participants form fields are not checked with asterix' do
        event.participant_form_fields.update_all options: { validations: { presence: false } }
        visit "/events/#{event.id}"

        expect(page).not_to have_content '*'
      end
    end
  end

  context 'Collecting requests campaign is not started' do
    let(:event) { create :event }

    it 'should show event' do
      visit "/events/#{event.id}"

      expect(page).to have_content event.title
    end

    it 'should not show participants form' do
      visit "/events/#{event.id}"

      expect(page).not_to have_xpath 'form.tramway_event_participant'
    end
  end
end

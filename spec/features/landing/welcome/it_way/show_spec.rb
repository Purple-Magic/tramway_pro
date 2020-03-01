# frozen_string_literal: true

require 'rails_helper'

describe 'IT Way: Show main page with events' do
  before { create :block, project_id: it_way_id }
  before { set_host it_way_host }

  context 'with main event' do
    it 'should show main page with started campaign' do
      event = create :event, :campaign_started, status: :main

      visit '/'

      expect(page).to have_content event.title
      event.participant_form_fields.each do |form_field|
        expect(page).to have_field "tramway_event_participant[#{form_field.title}]"
      end
    end

    it 'should show main page with not started campaign' do
      event = create :event, status: :main

      visit '/'

      expect(page).to have_content event.title
      expect(page).not_to have_xpath 'form.tramway_event_participant'
    end

    it 'should not show deleted main event' do
      create :event, :campaign_started, status: :main, state: :remove

      visit '/'

      expect(page).not_to have_xpath 'form.tramway_event_participant'
    end
  end

  context 'without main event' do
    it 'should not show main page with started campaign' do
      create :event, :campaign_started, status: :main

      visit '/'

      expect(page).not_to have_xpath 'form.tramway_event_participant'
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Show main page' do
  before { create :block }

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

  context 'with close events' do
    it 'should show close events from every admin and partner user' do
      Tramway::Event::Event.delete_all
      Tramway::User::User.delete_all
      events = Tramway::User::User.role.values.reduce({}) do |hash, role|
        create role
        hash.merge! role => create("event_created_by_#{role}", end_date: DateTime.now + 10.days)
      end

      visit '/'

      events.each do |pair|
        expect(page).to have_content pair[1].title
        expect(page).to have_content pair[1].short_description.split('.').first
      end
    end
  end
end

require 'rails_helper'

RSpec.feature 'Events show' do
  Tramway::Event::Event.active.each do |event|
    scenario "Visit event #{event.id} page" do
      visit "/events/#{event.id}"
      expect(page).to have_content event.title
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Index events' do
  before { set_host it_way_host }
  let!(:events) { create_list :event, 5, project_id: it_way_id }

  it 'should show index events page' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'

    events.each do |event|
      expect(page).to have_content event.title
    end
  end

  context 'show event_link' do
    before { create :event, project_id: it_way_id }

    it 'should show event_link' do
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_event = create :event, project_id: it_way_id
      click_on_dropdown 'Организация мероприятий'
      click_on 'Мероприятия'
      click_on last_event.title

      expect(page).to have_content ["#{it_way_host}/events/", last_event.id].join
    end
  end
end

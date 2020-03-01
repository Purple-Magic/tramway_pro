# frozen_string_literal: true

require 'rails_helper'

describe 'Edit event page' do
  before { set_host it_way_host }
  before { create :event, project_id: it_way_id }

  it 'should show edit event page' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_event = Tramway::Event::Event.active.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on last_event.title
    find('.btn.btn-warning', match: :first).click

    expect(page).to have_field 'record[title]', with: last_event.title
    expect(page).to have_field 'record[begin_date]', with: last_event.begin_date
    expect(page).to have_field 'record[end_date]', with: last_event.end_date
    expect(page).to have_field 'record[request_collecting_begin_date]', with: last_event.request_collecting_begin_date
    expect(page).to have_field 'record[request_collecting_end_date]', with: last_event.request_collecting_end_date
  end
end

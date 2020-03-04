# frozen_string_literal: true

require 'rails_helper'

describe 'Show event' do
  before { move_host_to it_way_host }
  before { create :event, project_id: it_way_id }

  it 'should show event' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_event = create :event, project_id: it_way_id
    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on last_event.title

    expect(page).to have_content last_event.title
  end
end

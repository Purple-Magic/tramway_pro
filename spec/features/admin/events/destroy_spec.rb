# frozen_string_literal: true

require 'rails_helper'

describe 'Destroy event' do
  before { move_host_to it_way_host }
  before { create :event, project_id: it_way_id }

  it 'should destroy event' do
    count = Tramway::Event::Event.count
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_event = Tramway::Event::Event.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on_delete_button last_event

    expect(Tramway::Event::Event.count).to be < count
  end
end

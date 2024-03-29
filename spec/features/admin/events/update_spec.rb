# frozen_string_literal: true

require 'rails_helper'

describe 'Update event' do
  before { move_host_to it_way_host }
  let!(:attributes) { attributes_for :event_admin_attributes }
  before { create :event, project_id: it_way_id }

  it 'should update event' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    event = Tramway::Event::Event.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title
    find('.btn.btn-warning', match: :first).click
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[begin_date]', with: attributes[:begin_date]
    fill_in 'record[end_date]', with: attributes[:end_date]
    fill_in 'record[request_collecting_begin_date]', with: attributes[:request_collecting_begin_date]
    fill_in 'record[request_collecting_end_date]', with: attributes[:request_collecting_end_date]
    select attributes[:reach], from: 'record[reach]'

    click_on 'Сохранить', class: 'btn-success'
    event.reload

    assert_attributes event, attributes
  end
end

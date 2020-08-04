# frozen_string_literal: true

require 'rails_helper'

describe 'Delete action' do
  before { create :event, project_id: it_way_id }
  before { move_host_to it_way_host }

  it 'deletes action' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_event = create :event, project_id: it_way_id
    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on last_event.title
    click_on 'Добавить действие'

    attributes = attributes_for :action_admin_attributes
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[deadline]', with: attributes[:deadline]

    click_on 'Сохранить'

    action = ::Tramway::Event::Action.last

    click_on_association_delete_button action
    action.reload
    expect(action.removed?).to be_truthy
  end

  it 'deletes mandatory action' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    find('.btn.btn-primary', match: :first).click
    attributes = attributes_for :event_admin_attributes
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[begin_date]', with: attributes[:begin_date]
    fill_in 'record[end_date]', with: attributes[:end_date]
    fill_in 'record[request_collecting_begin_date]', with: attributes[:request_collecting_begin_date]
    fill_in 'record[request_collecting_end_date]', with: attributes[:request_collecting_end_date]

    click_on 'Сохранить', class: 'btn-success'

    action = ::Tramway::Event::Action.last

    click_on_association_delete_button action
    action.reload
    expect(action.removed?).to be_truthy
  end
end
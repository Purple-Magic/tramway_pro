# frozen_string_literal: true

require 'rails_helper'

describe 'Delete participant_form_field' do
  before { create :event, project_id: it_way_id }
  before { move_host_to it_way_host }

  it 'deletes participant_form_field' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_event = create :event, project_id: it_way_id
    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on last_event.title
    click_on 'Добавить поле анкеты'

    attributes = attributes_for :participant_form_field_admin_attributes
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[description]', with: attributes[:description]
    fill_in 'record[position]', with: attributes[:position]
    select attributes[:field_type], from: 'record[field_type]'
    find('input[name="record[list_field]"]').click

    click_on 'Сохранить'

    field = ::Tramway::Event::ParticipantFormField.last

    click_on_association_delete_button field
    field.reload
    expect(field.remove?).to be_truthy
  end

  it 'deletes mandatory participant_form_field' do
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

    field = ::Tramway::Event::ParticipantFormField.last

    delete_path = ::Tramway::Admin::Engine.routes.url_helpers.record_path(
      field.id,
      model: Tramway::Event::ParticipantFormField
    )
    find("td[colspan='2'] td a[href='#{delete_path}']").parent_node(level: 2).find('td button[type="submit"]').click
    field.reload
    expect(field.remove?).to be_truthy
  end
end

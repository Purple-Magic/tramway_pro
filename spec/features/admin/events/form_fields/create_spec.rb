# frozen_string_literal: true

require 'rails_helper'

describe 'Create participant_form_field' do
  before { create :event, project_id: it_way_id }
  before { set_host it_way_host }

  it 'creates new participant_form_field' do
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

    request_uri = URI.parse(current_url).request_uri
    expect(request_uri).to eq(
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(last_event.id, model: 'Tramway::Event::Event')
    )

    last_participant_form_field = ::Tramway::Event::ParticipantFormField.last
    expect(page).to have_content last_participant_form_field.title
  end
end

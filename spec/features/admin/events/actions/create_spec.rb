# frozen_string_literal: true

require 'rails_helper'

describe 'Create action' do
  before { create :event, project_id: it_way_id }
  before { move_host_to it_way_host }

  it 'creates new action' do
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

    request_uri = URI.parse(current_url).request_uri
    expect(request_uri).to eq(
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(last_event.id, model: 'Tramway::Event::Event')
    )

    last_action = ::Tramway::Event::Action.last
    expect(page).to have_content last_action.title
  end
end

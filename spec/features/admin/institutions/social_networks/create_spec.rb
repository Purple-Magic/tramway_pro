# frozen_string_literal: true

require 'rails_helper'

describe 'Create social_network' do
  before { create :event, project_id: it_way_id }
  before { move_host_to it_way_host }

  it 'creates new social_network' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on 'Проект'
    click_on 'Добавить социальные сети'

    attributes = attributes_for :social_network_admin_add_to_unity_attributes
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[uid]', with: attributes[:uid]
    select attributes[:network_name], from: 'record[network_name]'

    click_on 'Сохранить'

    last_social_network = ::Tramway::Profiles::SocialNetwork.last
    expect(page).to have_content last_social_network.title
  end
end

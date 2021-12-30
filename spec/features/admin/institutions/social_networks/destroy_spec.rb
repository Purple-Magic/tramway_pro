# frozen_string_literal: true

require 'rails_helper'

describe 'Delete social_network' do
  before { move_host_to it_way_host }

  it 'deletes social_network' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on 'Проект'
    click_on 'Добавить социальные сети'

    attributes = attributes_for :social_network_admin_add_to_unity_attributes
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[uid]', with: attributes[:uid]
    select attributes[:network_name], from: 'record[network_name]'

    click_on 'Сохранить'

    social_network = ::Tramway::Profiles::SocialNetwork.last
    count = ::Tramway::Profiles::SocialNetwork.count
    click_on_association_delete_button social_network
    expect(::Tramway::Profiles::SocialNetwork.count).to be < count
  end
end

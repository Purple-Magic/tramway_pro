## frozen_string_literal: true
#
# require 'rails_helper'
#
# describe 'Create episode' do
#  before { create :podcast, project_id: it_way_id }
#  before { move_host_to it_way_host }
#
#  it 'creates new episode' do
#    visit '/admin'
#    fill_in 'Email', with: "admin#{it_way_id}@email.com"
#    fill_in 'Пароль', with: '123456'
#    click_on 'Войти', class: 'btn-success'
#
#    last_podcast = create :podcast, project_id: it_way_id
#    click_on 'Подкасты'
#    click_on last_podcast.title
#    click_on 'Добавить эпизод'
#
#    attributes = attributes_for :episode_admin_attributes
#    fill_in 'record[title]', with: attributes[:title]
#    fill_in 'record[description]', with: attributes[:description]
#
#    click_on 'Сохранить'
#
#    request_uri = URI.parse(current_url).request_uri
#    expect(request_uri).to eq(
#      ::Tramway::Admin::Engine.routes.url_helpers.record_path(last_podcast.id, model: 'Podcast')
#    )
#
#    last_episode = ::Tramway::Event::ParticipantFormField.last
#    expect(page).to have_content last_episode.title
#  end
# end

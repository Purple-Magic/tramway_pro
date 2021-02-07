## frozen_string_literal: true
#
# require 'rails_helper'
#
# describe 'Edit podcast page' do
#  before { move_host_to it_way_host }
#  before { create :podcast, project_id: it_way_id }
#
#  it 'should show edit podcast page' do
#    visit '/admin'
#    fill_in 'Email', with: "admin#{it_way_id}@email.com"
#    fill_in 'Пароль', with: '123456'
#    click_on 'Войти', class: 'btn-success'
#
#    last_podcast = Podcast.active.last
#    click_on 'Подкасты'
#    click_on last_podcast.title
#    find('.btn.btn-warning', match: :first).click
#
#    expect(page).to have_field 'record[title]', with: last_podcast.title
#    expect(page).to have_field 'record[feed_url]', with: last_podcast.feed_url
#  end
# end

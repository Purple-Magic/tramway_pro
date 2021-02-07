## frozen_string_literal: true
#
# require 'rails_helper'
#
# describe 'Update podcast' do
#  before { move_host_to it_way_host }
#  let!(:attributes) { attributes_for :podcast_admin_attributes }
#  before { create :podcast, project_id: it_way_id }
#
#  it 'should update podcast' do
#    visit '/admin'
#    fill_in 'Email', with: "admin#{it_way_id}@email.com"
#    fill_in 'Пароль', with: '123456'
#    click_on 'Войти', class: 'btn-success'
#
#    podcast = Podcast.last
#    click_on 'Подкасты'
#    click_on podcast.title
#    find('.btn.btn-warning', match: :first).click
#    fill_in 'record[title]', with: attributes[:title]
#    fill_in 'record[feed_url]', with: attributes[:feed_url]
#
#    click_on 'Сохранить', class: 'btn-success'
#    podcast.reload
#    attributes.keys.each do |attr|
#      actual = podcast.send(attr)
#      expecting = attributes[attr]
#      expect(actual).not_to be_empty, "#{attr} is empty"
#      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
#    end
#  end
# end

# frozen_string_literal: true

require 'rails_helper'

describe 'Create podcast' do
  before { move_host_to it_way_host }
  let!(:attributes) { attributes_for :podcast_admin_attributes }

  it 'should create podcast' do
    count = Podcast.count
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on 'Подкасты'
    find('.btn.btn-primary', match: :first).click
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[feed_url]', with: attributes[:feed_url]

    click_on 'Сохранить', class: 'btn-success'
    expect(Podcast.count).to eq(count + 1)
    podcast = Podcast.last
    attributes.keys.each do |attr|
      actual = podcast.send(attr)
      expecting = attributes[attr]
      expect(actual).not_to be_empty, "#{attr} is empty"
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end

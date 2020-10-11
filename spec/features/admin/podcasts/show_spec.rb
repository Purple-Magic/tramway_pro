# frozen_string_literal: true

require 'rails_helper'

describe 'Show podcast' do
  before { move_host_to it_way_host }
  before { create :podcast, project_id: it_way_id }

  it 'should show podcast' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_podcast = create :podcast, project_id: it_way_id
    click_on 'Подкасты'
    click_on last_podcast.title

    expect(page).to have_content last_podcast.title
  end
end

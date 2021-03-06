# frozen_string_literal: true

require 'rails_helper'

describe 'Show unity' do
  before { move_host_to it_way_host }

  it 'should show unity' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_unity = Tramway::Conference::Unity.last
    click_on 'Проект'

    expect(page).to have_content last_unity.title
  end
end

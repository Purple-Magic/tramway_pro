# frozen_string_literal: true

require 'rails_helper'

describe 'Show institution' do
  before { move_host_to it_way_host }

  it 'should show institution' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_institution = Tramway::SportSchool::Institution.last
    click_on 'Спортивная школа'

    expect(page).to have_content last_institution.title
  end
end

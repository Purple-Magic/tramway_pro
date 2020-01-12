# frozen_string_literal: true

require 'rails_helper'

describe 'Show admin' do
  before { create :admin }

  it 'should show admin' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_admin = create :admin
    click_on 'Пользователь'
    click_on last_admin.id

    expect(page).to have_content last_admin.email
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Edit admin page' do
  before { create :admin }

  it 'should show edit admin page' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_admin = Tramway::User::User.active.last
    click_on 'Пользователь'
    click_on last_admin.id
    find('.btn.btn-warning', match: :first).click

    expect(page).to have_field 'record[email]', with: last_admin.email
    expect(page).to have_field 'record[first_name]', with: last_admin.first_name
    expect(page).to have_field 'record[last_name]', with: last_admin.last_name
    expect(page).to have_select 'record[role]', selected: last_admin.role.text
  end
end

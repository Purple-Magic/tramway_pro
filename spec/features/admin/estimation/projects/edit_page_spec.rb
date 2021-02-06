# frozen_string_literal: true

require 'rails_helper'

describe 'Edit project page' do
  before do
    create :estimation_project, project_id: red_magic_id
  end

  it 'should show edit project page' do
    move_host_to red_magic_host
    visit '/admin'
    fill_in 'Email', with: "admin#{red_magic_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_project = Estimation::Project.last
    click_on_dropdown 'Оценки'
    click_on 'Проекты'
    click_on last_project.title
    find('.btn.btn-warning', match: :first).click

    expect(page).to have_field 'record[title]', with: last_project.title
    expect(page).to have_select 'record[customer]', selected: last_project.customer.title
  end
end

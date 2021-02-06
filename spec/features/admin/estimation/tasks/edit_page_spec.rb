# frozen_string_literal: true

require 'rails_helper'

describe 'Edit task page' do
  before do
    estimation_project = create :estimation_project, project_id: red_magic_id
    create :estimation_task, project_id: red_magic_id, estimation_project_id: estimation_project.id
  end

  it 'should show edit task page' do
    move_host_to red_magic_host
    visit '/admin'
    fill_in 'Email', with: "admin#{red_magic_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_project = Estimation::Project.where(project_id: red_magic_id).last
    click_on_dropdown 'Оценки'
    click_on 'Проекты'
    click_on last_project.title
    last_task = Estimation::Task.where(project_id: red_magic_id).last
    click_on last_task.title
    find('.btn.btn-warning', match: :first).click

    expect(page).to have_field 'record[title]', with: last_task.title
    expect(page).to have_field 'record[hours]', with: last_task.hours
    expect(page).to have_field 'record[price]', with: last_task.price
    expect(page).to have_field 'record[specialists_count]', with: last_task.specialists_count
    expect(page).to have_select 'record[estimation_project]', selected: last_task.estimation_project.title
  end
end

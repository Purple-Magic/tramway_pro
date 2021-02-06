# frozen_string_literal: true

require 'rails_helper'

describe 'Show estimation task' do
  before do
    estimation_project = create :estimation_project, project_id: red_magic_id
    create :estimation_task, project_id: red_magic_id, estimation_project: estimation_project
  end

  it 'should show estimation task' do
    puts "PROJECT URL: #{red_magic_host}".yellow
    move_host_to red_magic_host
    visit '/admin'
    fill_in 'Email', with: "admin#{red_magic_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_estimation_project = Estimation::Project.where(project_id: red_magic_id).last
    click_on_dropdown 'Оценки'
    click_on 'Проекты'
    click_on last_estimation_project.title
    last_block = Estimation::Task.where(project_id: red_magic_id).last
    click_on last_block.title

    expect(page).to have_content last_block.title
  end
end

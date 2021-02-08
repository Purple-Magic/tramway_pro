# frozen_string_literal: true

require 'rails_helper'

describe 'Update estimation_task' do
  let!(:attributes) { attributes_for :estimation_task_admin_attributes }
  before do
    estimation_project = create :estimation_project, project_id: red_magic_id
    create :estimation_task, project_id: red_magic_id, estimation_project: estimation_project
  end

  it 'should update estimation_task' do
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
    last_estimation_task = Estimation::Task.where(project_id: red_magic_id).last
    click_on last_estimation_task.title
    find('.btn.btn-warning', match: :first).click

    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[hours]', with: attributes[:hours]
    fill_in 'record[price]', with: attributes[:price]
    fill_in 'record[specialists_count]', with: attributes[:specialists_count]

    click_on 'Сохранить', class: 'btn-success'
    last_estimation_task.reload
    attributes.each_key do |attr|
      actual = last_estimation_task.send(attr)
      expecting = attributes[attr]
      case actual.class.to_s
      when 'NilClass'
        expect(actual).not_to be_empty, "#{attr} is empty"
      when 'Enumerize::Value'
        expect(actual).not_to be_empty, "#{attr} is empty"
        actual = actual.text
      when 'Estimation::Project'
        actual = actual.id
        expecting = last_estimation_project.id
      when 'PhotoUploader'
        actual = actual.url.split('/').last
        expecting = expecting.path.split('/').last
      end
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end

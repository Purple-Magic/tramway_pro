# frozen_string_literal: true

require 'rails_helper'

describe 'Update estimation_project' do
  let!(:attributes) { attributes_for :estimation_project }
  before do
    create :estimation_project, project_id: red_magic_id
  end

  it 'should update estimation_project' do
    move_host_to red_magic_host
    visit '/admin'
    fill_in 'Email', with: "admin#{red_magic_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_project = Estimation::Project.where(project_id: red_magic_id).last
    click_on_dropdown 'Оценки'
    click_on 'Проекты'
    click_on last_project.title
    find('.btn.btn-warning', match: :first).click

    fill_in 'record[title]', with: attributes[:title]
    select attributes[:customer].title, from: 'record[customer]'

    click_on 'Сохранить', class: 'btn-success'
    last_project.reload
    attributes.keys.each do |attr|
      actual = last_project.send(attr)
      expecting = attributes[attr]
      case actual.class.to_s
      when 'NilClass'
        expect(actual).not_to be_empty, "#{attr} is empty"
      when 'Enumerize::Value'
        expect(actual).not_to be_empty, "#{attr} is empty"
        actual = actual.text
      when 'PhotoUploader'
        actual = actual.url.split('/').last
        expecting = expecting.path.split('/').last
      end
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end

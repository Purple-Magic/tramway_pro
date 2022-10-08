# frozen_string_literal: true

require 'rails_helper'

describe 'Create estimation project', type: :feature do
  let!(:attributes) { attributes_for :estimation_project }

  ProjectsHelper.only('purple-magic', 'red-magic').each do |project|
    describe project.title do
      it 'should create estimation project' do
        project_id = project.id
        move_host_to project.url

        count = ::Estimation::Project.count
        visit '/admin'
        fill_in 'Email', with: "admin#{project_id}@email.com"
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on_dropdown 'Оценки'
        click_on 'Проекты'
        find('.btn.btn-primary', match: :first).click
        fill_in 'record[title]', with: attributes[:title]
        select attributes[:customer].title, from: 'record[customer]'

        click_on 'Сохранить', class: 'btn-success'
        expect(::Estimation::Project.count).to eq(count + 1)
        project = ::Estimation::Project.last
        attributes.each_key do |attr|
          actual = project.send(attr)
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
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Update block' do
  let!(:attributes) { attributes_for :block_admin_attributes }

  ProjectsHelper.projects_instead_of('listai', 'kalashnikovisme', 'tramway', 'freedvs').each do |project|
    before do
      landing_page = create :page, project_id: project.id
      create :block, project_id: project.id, page: landing_page
    end

    describe project.url do
      it 'should update block' do
        move_host_to project.url
        visit '/admin'
        fill_in 'Email', with: "admin#{project.id}@email.com"
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        last_page = Tramway::Page::Page.where(project_id: project.id).last
        click_on_dropdown 'Лендинг'
        click_on 'Страницы'
        click_on last_page.title
        last_block = Tramway::Landing::Block.where(project_id: project.id).last
        click_on last_block.title
        find('.btn.btn-warning', match: :first).click

        fill_in 'record[title]', with: attributes[:title]
        fill_in 'record[position]', with: attributes[:position]
        select attributes[:block_type], from: 'record[block_type]'
        select attributes[:navbar_link], from: 'record[navbar_link]'
        fill_in 'record[anchor]', with: attributes[:anchor]
        fill_in 'record[view_name]', with: attributes[:view_name]
        find('input[name="record[background]"]').set attributes[:background].path

        click_on 'Сохранить', class: 'btn-success'
        last_block.reload
        attributes.each_key do |attr|
          actual = last_block.send(attr)
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

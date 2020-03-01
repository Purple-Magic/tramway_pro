# frozen_string_literal: true

require 'rails_helper'

describe 'Edit block page' do
  ProjectsHelper.projects.each do |project|
    before { create :block, project_id: project.id }

    it 'should show edit block page' do
      set_host project.url
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Password', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_block = Tramway::Landing::Block.active.where(project_id: project.id).last

      click_on_dropdown 'Лендинг'
      click_on 'Блоки'
      click_on last_block.title
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[title]', with: last_block.title
      expect(page).to have_field 'record[position]', with: last_block.position
      expect(page).to have_field 'record[view_name]', with: last_block.view_name
      expect(page).to have_select 'record[block_type]', selected: last_block.block_type.text
      expect(page).to have_select 'record[navbar_link]', selected: last_block.navbar_link.text
    end
  end
end

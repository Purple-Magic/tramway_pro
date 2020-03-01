# frozen_string_literal: true

require 'rails_helper'

describe 'Show block' do
  ProjectsHelper.projects.each do |project|
    before { create :block, project_id: project.id }

    it 'should show block' do
      set_host project.url
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_block = Tramway::Landing::Block.active.where(project_id: project.id).last
      click_on_dropdown 'Лендинг'
      click_on 'Блоки'
      click_on last_block.title

      expect(page).to have_content last_block.title
    end
  end
end

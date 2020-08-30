# frozen_string_literal: true

require 'rails_helper'

describe 'Show block' do
  ProjectsHelper.projects.each do |project|
    before do
      landing_page = create :page, project_id: project.id
      create :block, project_id: project.id, page: landing_page
    end
    unless project.url.in? ['listai.test', 'kalashnikovisme.test', 'engineervol.test', 'purple-magic.test', 'gorodsad73.test']
      it 'should show block' do
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
  
        expect(page).to have_content last_block.title
      end
    end
  end
end

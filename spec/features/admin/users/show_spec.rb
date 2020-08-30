# frozen_string_literal: true

require 'rails_helper'

describe 'Show admin' do
  ProjectsHelper.projects.each do |project|
    before { create :admin, project_id: project.id }

    unless project.url.in? ['listai.test', 'kalashnikovisme.test']
      it "#{project.url}: should show admin" do
        move_host_to project.url
        visit '/admin'
        fill_in 'Email', with: "admin#{project.id}@email.com"
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'
  
        last_admin = create :admin, project_id: project.id
        click_on 'Пользователи'
        click_on last_admin.id
  
        expect(page).to have_content last_admin.email
      end
    end
  end
end

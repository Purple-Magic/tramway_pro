# frozen_string_literal: true

require 'rails_helper'

describe 'Edit admin page' do
  ProjectsHelper.projects_instead_of('listai', 'kalashnikovisme', 'tramway', 'benchkiller').each do |project|
    before { create :admin, project_id: project.id }

    it "#{project.url}: should show edit admin page" do
      move_host_to project.url
      visit '/admin'
      fill_in 'Email', with: "admin#{project.id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_admin = Tramway::User.where(project_id: project.id).last
      click_on 'Пользователи'
      click_on last_admin.id
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[email]', with: last_admin.email
      expect(page).to have_field 'record[first_name]', with: last_admin.first_name
      expect(page).to have_field 'record[last_name]', with: last_admin.last_name
      expect(page).to have_select 'record[role]', selected: last_admin.role.text
    end
  end
end

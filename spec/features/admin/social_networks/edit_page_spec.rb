# frozen_string_literal: true

require 'rails_helper'

describe 'Edit social_network page' do
  ProjectsHelper.projects.each do |project|
    before { create :social_network, project_id: project.id }

    it 'should show edit social_network page' do
      move_host_to project.url
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_social_network = Tramway::Profiles::SocialNetwork.active.where(project_id: project.id).last

      click_on_dropdown 'Лендинг'
      click_on 'Социальные сети'
      click_on last_social_network.title
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[title]', with: last_social_network.title
      expect(page).to have_field 'record[uid]', with: last_social_network.uid
      expect(page).to have_select 'record[network_name]', selected: last_social_network.network_name.text
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Show social_network' do
  ProjectsHelper.projects.each do |project|
    before { create :social_network, project_id: project.id }

    it 'should show social_network' do
      move_host_to project.url
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_social_network = Tramway::Profiles::SocialNetwork.active.where(project_id: project.id).last
      click_on_dropdown 'Лендинг'
      click_on 'Социальные сети'
      click_on last_social_network.title

      expect(page).to have_content last_social_network.title
    end
  end
end

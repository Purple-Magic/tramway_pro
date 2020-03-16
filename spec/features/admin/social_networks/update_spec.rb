# frozen_string_literal: true

require 'rails_helper'

describe 'Update social_network' do
  let!(:attributes) { attributes_for :social_network_admin_attributes }
  ProjectsHelper.projects.each do |project|
    before { create :social_network, project_id: project.id }

    it 'should update social_network' do
      move_host_to project.url
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      social_network = Tramway::Profiles::SocialNetwork.active.where(project_id: project.id).last
      click_on_dropdown 'Лендинг'
      click_on 'Социальные сети'
      click_on social_network.title
      find('.btn.btn-warning', match: :first).click
      fill_in 'record[title]', with: attributes[:title]
      fill_in 'record[uid]', with: attributes[:uid]
      select attributes[:network_name], from: 'record[network_name]'
      select attributes[:record], from: 'record[record]'

      click_on 'Сохранить', class: 'btn-success'
      social_network.reload
      attributes.keys.each do |attr|
        actual = social_network.send(attr)
        expecting = attributes[attr]
        case actual.class.to_s
        when 'NilClass'
          expect(actual).not_to be_empty, "#{attr} is empty"
        when 'Enumerize::Value'
          expect(actual).not_to be_empty, "#{attr} is empty"
          actual = actual.text
        when 'Tramway::SportSchool::Institution', 'Tramway::Conference::Unity'
          expect(actual).to be_present, "#{attr} is empty"
          actual = "#{actual.class.model_name.human} | #{actual.title}"
        end
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end
end

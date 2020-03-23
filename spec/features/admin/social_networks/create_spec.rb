# frozen_string_literal: true

require 'rails_helper'

describe 'Create social_network' do
  let!(:attributes) { attributes_for :social_network_admin_attributes }

  ProjectsHelper.projects.each do |project|
    it "#{project.url}: should create social_network" do
      move_host_to project.url
      count = Tramway::Profiles::SocialNetwork.count
      visit '/admin'
      fill_in 'Email', with: 'admin@email.com'
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on_dropdown 'Лендинг'
      click_on 'Социальные сети'
      find('.btn.btn-primary', match: :first).click
      fill_in 'record[title]', with: attributes[:title]
      fill_in 'record[uid]', with: attributes[:uid]
      select attributes[:network_name], from: 'record[network_name]'
      select attributes[:record], from: 'record[record]'

      click_on 'Сохранить', class: 'btn-success'
      expect(Tramway::Profiles::SocialNetwork.count).to eq(count + 1)
      social_network = Tramway::Profiles::SocialNetwork.last
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
        when 'Tramway::User::User'
          expect(actual).to be_present, "#{attr} is empty"
          actual = "#{actual.class.model_name.human} | #{actual.first_name} #{actual.last_name}"
        end
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end
end

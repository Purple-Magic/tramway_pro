# frozen_string_literal: true

require 'rails_helper'

describe 'Create admin' do
  let!(:attributes) { attributes_for :admin_admin_attributes }

  ProjectsHelper.projects_instead_of(
    :listai, :kalashnikovisme, :engineervol, :tramway, 'red-magic', 'benchkiller'
  ).each do |project|
    it "#{project.url}: should create admin" do
      move_host_to project.url
      visit '/admin'
      fill_in 'Email', with: "admin#{project.id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      count = Tramway::User.where(project_id: project.id).count
      click_on 'Пользователи'
      find('.btn.btn-primary', match: :first).click
      fill_in 'record[email]', with: attributes[:email]
      fill_in 'record[password]', with: attributes[:password]
      fill_in 'record[first_name]', with: attributes[:first_name]
      fill_in 'record[last_name]', with: attributes[:last_name]
      select attributes[:role], from: 'record[role]'

      click_on 'Сохранить', class: 'btn-success'
      expect(Tramway::User.where(project_id: project.id).count).to eq(count + 1)
      admin = Tramway::User.where(project_id: project.id).last
      attributes.each_key do |attr|
        next if attr == :password

        actual = admin.send(attr)
        expecting = attributes[attr]
        case actual.class.to_s
        when 'NilClass'
          expect(actual).not_to be_empty, "#{attr} is empty"
        when 'Enumerize::Value'
          expect(actual).not_to be_empty, "#{attr} is empty"
          actual = actual.text
        end
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end

    it "#{project.url}: should create admin with existing email in another project" do
      existed_email = (create :admin, project_id: project.id + 1).email

      move_host_to project.url

      visit '/admin'
      fill_in 'Email', with: "admin#{project.id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      count = Tramway::User.where(project_id: project.id).count
      click_on 'Пользователи'
      find('.btn.btn-primary', match: :first).click
      fill_in 'record[email]', with: existed_email
      fill_in 'record[password]', with: attributes[:password]
      fill_in 'record[first_name]', with: attributes[:first_name]
      fill_in 'record[last_name]', with: attributes[:last_name]
      select attributes[:role], from: 'record[role]'

      click_on 'Сохранить', class: 'btn-success'
      expect(Tramway::User.where(project_id: project.id).count).to eq(count + 1)
      admin = Tramway::User.where(project_id: project.id).last
      attributes.each_key do |attr|
        next if attr == :password

        actual = admin.send(attr)
        expecting = attr == :email ? existed_email : attributes[attr]
        case actual.class.to_s
        when 'NilClass'
          expect(actual).not_to be_empty, "#{attr} is empty"
        when 'Enumerize::Value'
          expect(actual).not_to be_empty, "#{attr} is empty"
          actual = actual.text
        end
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end
end

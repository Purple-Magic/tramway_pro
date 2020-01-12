# frozen_string_literal: true

require 'rails_helper'

describe 'Create admin' do
  let!(:attributes) { attributes_for :admin_admin_attributes }

  it 'should create admin' do
    count = Tramway::User::User.count
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on 'Пользователь'
    find('.btn.btn-primary', match: :first).click
    fill_in 'record[email]', with: attributes[:email]
    fill_in 'record[password]', with: attributes[:password]
    fill_in 'record[first_name]', with: attributes[:first_name]
    fill_in 'record[last_name]', with: attributes[:last_name]
    select attributes[:role], from: 'record[role]'

    click_on 'Сохранить', class: 'btn-success'
    expect(Tramway::User::User.count).to eq(count + 1)
    admin = Tramway::User::User.last
    attributes.keys.each do |attr|
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
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Create block' do
  let!(:attributes) { attributes_for :block_admin_attributes }

  it 'should create block' do
    count = Tramway::Landing::Block.count
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on 'Блок'
    find('.btn.btn-primary', match: :first).click
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[position]', with: attributes[:position]
    select attributes[:block_type], from: 'record[block_type]'
    select attributes[:navbar_link], from: 'record[navbar_link]'
    fill_in 'record[anchor]', with: attributes[:anchor]
    fill_in 'record[view_name]', with: attributes[:view_name]
    find('input[name="record[background]"]').set attributes[:background].path

    click_on 'Сохранить', class: 'btn-success'
    expect(Tramway::Landing::Block.count).to eq(count + 1)
    block = Tramway::Landing::Block.last
    attributes.keys.each do |attr|
      actual = block.send(attr)
      expecting = attributes[attr]
      case actual.class.to_s
      when 'NilClass'
        expect(actual).not_to be_empty, "#{attr} is empty"
      when 'Enumerize::Value'
        expect(actual).not_to be_empty, "#{attr} is empty"
        actual = actual.text
      when 'PhotoUploader'
        actual = actual.url.split('/').last
        expecting = expecting.path.split('/').last
      end
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end

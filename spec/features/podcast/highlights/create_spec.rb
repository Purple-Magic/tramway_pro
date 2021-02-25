# frozen_string_literal: true

require 'rails_helper'

describe 'Create podcast highlight' do
  let!(:attributes) { attributes_for :podcast_highlight }

  before { create :page, slug: 'podcast_highlight', view: 'podcast_highlight' }

  it 'IT Ways hould create podcast highlight' do
    move_host_to it_way_host
    count = ::Estimation::Project.count
    visit '/page/podcast_highlight'
    fill_in 'Email', with: "admin#{project_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Оценки'
    click_on 'Проекты'
    find('.btn.btn-primary', match: :first).click
    fill_in 'record[title]', with: attributes[:title]
    select attributes[:customer].title, from: 'record[customer]'

    click_on 'Сохранить', class: 'btn-success'
    expect(::Estimation::Project.count).to eq(count + 1)
    project = ::Estimation::Project.last
    attributes.each_key do |attr|
      actual = project.send(attr)
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

# frozen_string_literal: true

require 'rails_helper'

describe 'Create course' do
  before { move_host_to kalashnikovisme_host }

  ::Course::TEAMS.each do |team|
    let(:attributes) { attributes_for :course, team: team }

    it 'should create course' do
      count = Course.count
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      find('.btn.btn-primary', match: :first).click
      fill_in 'record[title]', with: attributes[:title]
      select attributes[:team].to_s.capitalize, from: 'record[team]'

      click_on 'Сохранить', class: 'btn-success'
      expect(Course.count).to eq(count + 1)

      course = Course.last
      attributes.each_key do |attr|
        actual = course.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end
end

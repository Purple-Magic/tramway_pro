# frozen_string_literal: true

require 'rails_helper'

describe 'Edit course page' do
  before { move_host_to kalashnikovisme_host }

  ::Course::TEAMS.each do |team|
    before { create :course, team: team, project_id: kalashnikovisme_id }

    it "#{team.to_s.capitalize} team: should show edit course page" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_course = Course.last
      click_on 'Курсы'
      click_on last_course.title
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[title]', with: last_course.title
      expect(page).to have_select 'record[team]', selected: last_course.team.capitalize
    end

    it "#{team.to_s.capitalize} team: should update course" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_course = Course.last
      click_on 'Курсы'
      click_on last_course.title
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :course

      fill_in 'record[title]', with: attributes[:title]

      click_on 'Сохранить', class: 'btn-success'

      last_course.reload

      attributes.each_key do |attr|
        next if attr == :team

        actual = last_course.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Edit course page' do
  before { move_host_to kalashnikovisme_host }

  ::Course::TEAMS.each do |team|
    before { create :course, team: team }

    it 'should show edit course page' do
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
  end
end

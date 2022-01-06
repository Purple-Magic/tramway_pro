# frozen_string_literal: true

require 'rails_helper'

describe 'Show course page' do
  before { move_host_to kalashnikovisme_host }

  ::Course::TEAMS.each do |team|
    before do
      create(:course, team: team, project_id: kalashnikovisme_id) do |course|
        4.times do |i|
          course.topics.create attributes_for :courses_topic, position: i, project_id: kalashnikovisme_id
        end
      end
    end

    it "#{team.to_s.capitalize} team: should show course page" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_course = Course.last
      click_on 'Курсы'
      click_on last_course.title

      expect(page).to have_content last_course.title

      last_course.topics.each do |topic|
        expect(page).to have_content "#{topic.model_name.human} #{topic.position} | #{topic.title}"

        url = Tramway::Admin::Engine.routes.url_helpers.record_path(topic.id, model: topic.model_name)
        within('ul.tree') do
          page.should have_selector "li a[href='#{url}']"
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Edit topic page' do
  before { move_host_to kalashnikovisme_host }

  describe 'Admin' do
    let!(:topic) do
      create :courses_topic, project_id: kalashnikovisme_id, course: create(:course, project_id: kalashnikovisme_id)
    end

    it "should show edit topic page" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on topic.course.title
      within 'ul.tree' do
        click_on "#{topic.model_name.human} #{topic.position} | #{topic.title}"
      end
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[title]', with: topic.title
      expect(page).to have_field 'record[position]', with: topic.position
    end

    it "should update topic" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on topic.course.title
      within 'ul.tree' do
        click_on "#{topic.model_name.human} #{topic.position} | #{topic.title}"
      end
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :courses_topic

      fill_in 'record[title]', with: attributes[:title]
      fill_in 'record[position]', with: attributes[:position]

      click_on 'Сохранить', class: 'btn-success'

      topic.reload

      attributes.each_key do |attr|
        actual = topic.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end


  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
      let!(:topic) { create :courses_topic, project_id: kalashnikovisme_id }

      it 'should show edit topic page' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic.update! course: course
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on topic.course.title
        within 'ul.tree' do
          click_on "#{topic.model_name.human} #{topic.position} | #{topic.title}"
        end
        find('.btn.btn-warning', match: :first).click

        expect(page).to have_field 'record[title]', with: topic.title
        expect(page).to have_field 'record[position]', with: topic.position
      end

      it 'should update topic' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic.update! course: course
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on topic.course.title
        within 'ul.tree' do
          click_on "#{topic.model_name.human} #{topic.position} | #{topic.title}"
        end
        find('.btn.btn-warning', match: :first).click

        attributes = attributes_for :courses_topic

        fill_in 'record[title]', with: attributes[:title]
        fill_in 'record[position]', with: attributes[:position]

        click_on 'Сохранить', class: 'btn-success'

        topic.reload

        attributes.each_key do |attr|
          actual = topic.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end
    end
  end
end

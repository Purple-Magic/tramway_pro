# frozen_string_literal: true

require 'rails_helper'

describe 'Edit lesson page' do
  before { move_host_to kalashnikovisme_host }

  describe 'Admin' do
    let!(:lesson) do
      topic = create :courses_topic,
        project_id: kalashnikovisme_id,
        course: create(:course, project_id: kalashnikovisme_id)
      create :courses_lesson, project_id: kalashnikovisme_id, topic: topic
    end

    it 'should show edit lesson page' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on lesson.topic.course.title
      within 'ul.tree' do
        click_on "#{lesson.model_name.human} #{lesson.topic.position}-#{lesson.position} | #{lesson.title}"
      end
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[title]', with: lesson.title
      expect(page).to have_field 'record[position]', with: lesson.position
    end

    it 'should update lesson' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on lesson.topic.course.title
      within 'ul.tree' do
        click_on "#{lesson.model_name.human} #{lesson.topic.position}-#{lesson.position} | #{lesson.title}"
      end
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :courses_lesson

      fill_in 'record[title]', with: attributes[:title]
      fill_in 'record[position]', with: attributes[:position]

      click_on 'Сохранить', class: 'btn-success'

      lesson.reload

      attributes.each_key do |attr|
        next if attr == :topic

        actual = lesson.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
      let!(:lesson) { create :courses_lesson, project_id: kalashnikovisme_id }

      it 'should show edit lesson page' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        lesson.update! topic: course.topics.create!(**attributes_for(:courses_topic), course: course)
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on lesson.topic.course.title
        within 'ul.tree' do
          click_on "#{lesson.model_name.human} #{lesson.topic.position}-#{lesson.position} | #{lesson.title}"
        end
        find('.btn.btn-warning', match: :first).click

        expect(page).to have_field 'record[title]', with: lesson.title
        expect(page).to have_field 'record[position]', with: lesson.position
      end

      it 'should update lesson' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        lesson.update! topic: course.topics.create!(**attributes_for(:courses_topic), course: course)
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on lesson.topic.course.title
        within 'ul.tree' do
          click_on "#{lesson.model_name.human} #{lesson.topic.position}-#{lesson.position} | #{lesson.title}"
        end
        find('.btn.btn-warning', match: :first).click

        attributes = attributes_for :courses_lesson

        fill_in 'record[title]', with: attributes[:title]
        fill_in 'record[position]', with: attributes[:position]

        click_on 'Сохранить', class: 'btn-success'

        lesson.reload

        attributes.each_key do |attr|
          next if attr == :topic

          actual = lesson.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end
    end
  end
end

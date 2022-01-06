# frozen_string_literal: true

require 'rails_helper'

describe 'Edit task page' do
  before { move_host_to kalashnikovisme_host }

  describe 'Admin' do
    let!(:task) do
      topic = create :courses_topic,
        project_id: kalashnikovisme_id,
        course: create(:course, project_id: kalashnikovisme_id)
      lesson = create :courses_lesson, project_id: kalashnikovisme_id, topic: topic
      create :courses_task, lesson: lesson, project_id: kalashnikovisme_id
    end

    it 'should show edit task page' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on task.lesson.topic.course.title
      within 'ul.tree' do
        click_on Courses::TaskDecorator.new(task).title
      end
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[text]', with: task.text
      expect(page).to have_field 'record[position]', with: task.position
      expect(page).to have_field 'record[min_time]', with: task.min_time
      expect(page).to have_field 'record[max_time]', with: task.max_time
    end

    it 'should update task' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on task.lesson.topic.course.title
      within 'ul.tree' do
        click_on Courses::TaskDecorator.new(task).title
      end
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :courses_task

      fill_in 'record[text]', with: attributes[:text]
      fill_in 'record[position]', with: attributes[:position]
      fill_in 'record[min_time]', with: attributes[:min_time]
      fill_in 'record[max_time]', with: attributes[:max_time]

      click_on 'Сохранить', class: 'btn-success'

      task.reload

      attributes.each_key do |attr|
        next if attr == :lesson

        actual = task.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
      let!(:task) { create :courses_task, project_id: kalashnikovisme_id }

      it 'should show edit task page' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        task.update! lesson: topic.lessons.create!(attributes_for(:courses_lesson))
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on task.lesson.topic.course.title
        within 'ul.tree' do
          click_on Courses::TaskDecorator.new(task).title
        end
        find('.btn.btn-warning', match: :first).click

        expect(page).to have_field 'record[text]', with: task.text
        expect(page).to have_field 'record[position]', with: task.position
        expect(page).to have_field 'record[min_time]', with: task.min_time
        expect(page).to have_field 'record[max_time]', with: task.max_time
      end

      it 'should update task' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        task.update! lesson: topic.lessons.create!(attributes_for(:courses_lesson))
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on task.lesson.topic.course.title
        within 'ul.tree' do
          click_on Courses::TaskDecorator.new(task).title
        end
        find('.btn.btn-warning', match: :first).click

        attributes = attributes_for :courses_task

        fill_in 'record[text]', with: attributes[:text]
        fill_in 'record[position]', with: attributes[:position]
        fill_in 'record[min_time]', with: attributes[:min_time]
        fill_in 'record[max_time]', with: attributes[:max_time]

        click_on 'Сохранить', class: 'btn-success'

        task.reload

        attributes.each_key do |attr|
          next if attr == :lesson

          actual = task.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end
    end
  end
end

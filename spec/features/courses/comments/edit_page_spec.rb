# frozen_string_literal: true

require 'rails_helper'

describe 'Edit comment page' do
  before { move_host_to kalashnikovisme_host }

  describe 'Admin' do
    let!(:comment) do
      topic = create :courses_topic,
        project_id: kalashnikovisme_id,
        course: create(:course, project_id: kalashnikovisme_id)
      lesson = create :courses_lesson, project_id: kalashnikovisme_id, topic: topic
      associated_type = Courses::Comment.associated_type.values.sample
      associated = create associated_type.underscore.gsub('/', '_'), lesson: lesson
      create :courses_comment, associated: associated, project_id: kalashnikovisme_id
    end

    it 'should show edit comment page' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on comment.associated.lesson.topic.course.title
      within 'ul.tree' do
        click_on associated_title comment
      end
      click_on comment.text
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[text]', with: comment.text
      expect(page).to have_field 'record[begin_time]', with: comment.begin_time
      expect(page).to have_field 'record[end_time]', with: comment.end_time
      expect(page).to have_field 'record[phrase]', with: comment.phrase
    end

    it 'should update comment' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on comment.associated.lesson.topic.course.title
      within 'ul.tree' do
        click_on associated_title comment
      end
      click_on comment.text
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :courses_comment

      fill_in 'record[begin_time]', with: attributes[:begin_time]
      fill_in 'record[end_time]', with: attributes[:end_time]
      fill_in 'record[phrase]', with: attributes[:phrase]
      fill_in 'record[text]', with: attributes[:text]

      click_on 'Сохранить', class: 'btn-success'

      comment.reload

      attributes.each_key do |attr|
        next if attr == :associated

        actual = comment.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
      let!(:comment) { create :courses_comment, project_id: kalashnikovisme_id }

      it 'should show edit comment page' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        lesson = topic.lessons.create!(attributes_for(:courses_lesson))
        associated_type = Courses::Comment.associated_type.values.sample
        comment.update! associated: create(associated_type.underscore.gsub('/', '_'), lesson: lesson)
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on comment.associated.lesson.topic.course.title
        within 'ul.tree' do
          click_on associated_title comment
        end
        click_on comment.text
        find('.btn.btn-warning', match: :first).click

        expect(page).to have_field 'record[text]', with: comment.text
        expect(page).to have_field 'record[begin_time]', with: comment.begin_time
        expect(page).to have_field 'record[end_time]', with: comment.end_time
        expect(page).to have_field 'record[phrase]', with: comment.phrase
      end

      it 'should update comment' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        lesson = topic.lessons.create!(attributes_for(:courses_lesson))
        associated_type = Courses::Comment.associated_type.values.sample
        comment.update! associated: create(associated_type.underscore.gsub('/', '_'), lesson: lesson)
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on comment.associated.lesson.topic.course.title
        within 'ul.tree' do
          click_on associated_title(comment)
        end
        click_on comment.text
        find('.btn.btn-warning', match: :first).click

        attributes = attributes_for :courses_comment

        fill_in 'record[begin_time]', with: attributes[:begin_time]
        fill_in 'record[end_time]', with: attributes[:end_time]
        fill_in 'record[phrase]', with: attributes[:phrase]
        fill_in 'record[text]', with: attributes[:text]

        click_on 'Сохранить', class: 'btn-success'

        comment.reload

        attributes.each_key do |attr|
          next if attr == :associated

          actual = comment.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end
    end
  end
end

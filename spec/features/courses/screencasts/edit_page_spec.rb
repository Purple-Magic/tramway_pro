# frozen_string_literal: true

require 'rails_helper'

describe 'Edit screencast page' do
  before { move_host_to kalashnikovisme_host }

  describe 'Admin' do
    let!(:screencast) do
      topic = create :courses_topic,
        project_id: kalashnikovisme_id,
        course: create(:course, project_id: kalashnikovisme_id)
      lesson = create :courses_lesson, project_id: kalashnikovisme_id, topic: topic
      video = create :courses_video, lesson: lesson
      create :courses_screencast, video: video, project_id: kalashnikovisme_id
    end

    it 'should show edit screencast page' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on screencast.video.lesson.topic.course.title
      within 'ul.tree' do
        click_on Courses::VideoDecorator.new(screencast.video).title
      end
      click_on "#{screencast.begin_time}-#{screencast.end_time}"
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[begin_time]', with: screencast.begin_time
      expect(page).to have_field 'record[end_time]', with: screencast.end_time
    end

    it 'should update screencast' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on screencast.video.lesson.topic.course.title
      within 'ul.tree' do
        click_on Courses::VideoDecorator.new(screencast.video).title
      end
      click_on "#{screencast.begin_time}-#{screencast.end_time}"
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :courses_screencast

      fill_in 'record[begin_time]', with: attributes[:begin_time]
      fill_in 'record[end_time]', with: attributes[:end_time]

      click_on 'Сохранить', class: 'btn-success'

      screencast.reload

      assert_attributes screencast, attributes, additionals: { video: screencast.video }
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
      let!(:screencast) { create :courses_screencast, project_id: kalashnikovisme_id }

      it 'should show edit screencast page' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        lesson = topic.lessons.create!(attributes_for(:courses_lesson))
        video = create(:courses_video, lesson: lesson)
        screencast.update! video: video
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on screencast.video.lesson.topic.course.title
        within 'ul.tree' do
          click_on Courses::VideoDecorator.new(video).title
        end
        click_on "#{screencast.begin_time}-#{screencast.end_time}"
        find('.btn.btn-warning', match: :first).click

        expect(page).to have_field 'record[begin_time]', with: screencast.begin_time
        expect(page).to have_field 'record[end_time]', with: screencast.end_time
      end

      it 'should update screencast' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        lesson = topic.lessons.create!(attributes_for(:courses_lesson))
        video = create(:courses_video, lesson: lesson)
        screencast.update! video: video
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on screencast.video.lesson.topic.course.title
        within 'ul.tree' do
          click_on Courses::VideoDecorator.new(video).title
        end
        click_on "#{screencast.begin_time}-#{screencast.end_time}"
        find('.btn.btn-warning', match: :first).click

        attributes = attributes_for :courses_screencast

        fill_in 'record[begin_time]', with: attributes[:begin_time]
        fill_in 'record[end_time]', with: attributes[:end_time]

        click_on 'Сохранить', class: 'btn-success'

        screencast.reload

        assert_attributes screencast, attributes, additionals: { video: video }
      end
    end
  end
end

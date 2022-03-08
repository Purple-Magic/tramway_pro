# frozen_string_literal: true

require 'rails_helper'

describe 'Edit video page' do
  before { move_host_to kalashnikovisme_host }

  describe 'Admin' do
    let!(:video) do
      topic = create :courses_topic,
        project_id: kalashnikovisme_id,
        course: create(:course, project_id: kalashnikovisme_id)
      lesson = create :courses_lesson, project_id: kalashnikovisme_id, topic: topic
      create :courses_video, lesson: lesson, project_id: kalashnikovisme_id, release_date: nil
    end

    it 'should show edit video page' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on video.lesson.topic.course.title
      within 'ul.tree' do
        click_on Courses::VideoDecorator.new(video).title
      end
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[position]', with: video.position
      expect(page).to have_field 'record[duration]', with: video.duration
    end

    it 'should update video' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on video.lesson.topic.course.title
      within 'ul.tree' do
        click_on Courses::VideoDecorator.new(video).title
      end
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :courses_video

      fill_in_ckeditor 'record[text]', with: attributes[:text]
      fill_in 'record[position]', with: attributes[:position]
      fill_in 'record[release_date]', with: attributes[:release_date]
      fill_in 'record[duration]', with: attributes[:duration]

      click_on 'Сохранить', class: 'btn-success'

      video.reload

      assert_attributes video, attributes
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
      let!(:video) { create :courses_video, project_id: kalashnikovisme_id }

      it 'should show edit video page' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        video.update! lesson: topic.lessons.create!(attributes_for(:courses_lesson))
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on video.lesson.topic.course.title
        within 'ul.tree' do
          click_on Courses::VideoDecorator.new(video).title
        end
        find('.btn.btn-warning', match: :first).click

        expect(page).to have_field 'record[position]', with: video.position
        expect(page).to have_field 'record[release_date]', with: video.release_date
        expect(page).to have_field 'record[duration]', with: video.duration
      end

      it 'should update video' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        video.update! lesson: topic.lessons.create!(attributes_for(:courses_lesson))
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on video.lesson.topic.course.title
        within 'ul.tree' do
          click_on Courses::VideoDecorator.new(video).title
        end
        find('.btn.btn-warning', match: :first).click

        attributes = attributes_for :courses_video

        fill_in_ckeditor 'record[text]', with: attributes[:text]
        fill_in 'record[position]', with: attributes[:position]
        fill_in 'record[release_date]', with: attributes[:release_date]
        fill_in 'record[duration]', with: attributes[:duration]

        click_on 'Сохранить', class: 'btn-success'

        video.reload

        assert_attributes video, attributes
      end
    end
  end
end

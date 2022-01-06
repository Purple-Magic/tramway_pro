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
      video_title = "#{video.model_name.human} #{video.lesson.topic.position}-#{video.lesson.position}-#{video.position} | #{video.comments.count} comments | #{video.comments.done.count} comments done | #{video.duration}"
      within 'ul.tree' do
        click_on video_title
      end
      find('.btn.btn-warning', match: :first).click

      expect(page).to have_field 'record[text]', with: video.text
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
      video_title = "#{video.model_name.human} #{video.lesson.topic.position}-#{video.lesson.position}-#{video.position} | #{video.comments.count} comments | #{video.comments.done.count} comments done | #{video.duration}"
      within 'ul.tree' do
        click_on video_title
      end
      find('.btn.btn-warning', match: :first).click

      attributes = attributes_for :courses_video

      fill_in 'record[text]', with: attributes[:text]
      fill_in 'record[position]', with: attributes[:position]
      fill_in 'record[release_date]', with: attributes[:release_date]
      fill_in 'record[duration]', with: attributes[:duration]

      click_on 'Сохранить', class: 'btn-success'

      video.reload

      attributes.each_key do |attr|
        next if attr == :lesson

        actual = video.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
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
        video_title = "#{video.model_name.human} #{video.lesson.topic.position}-#{video.lesson.position}-#{video.position} | #{video.comments.count} comments | #{video.comments.done.count} comments done | #{video.duration}"
        within 'ul.tree' do
          click_on video_title
        end
        find('.btn.btn-warning', match: :first).click

        expect(page).to have_field 'record[text]', with: video.text
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
        video_title = "#{video.model_name.human} #{video.lesson.topic.position}-#{video.lesson.position}-#{video.position} | #{video.comments.count} comments | #{video.comments.done.count} comments done | #{video.duration}"
        within 'ul.tree' do
          click_on video_title
        end
        find('.btn.btn-warning', match: :first).click

        attributes = attributes_for :courses_video

        fill_in 'record[text]', with: attributes[:text]
        fill_in 'record[position]', with: attributes[:position]
        fill_in 'record[release_date]', with: attributes[:release_date]
        fill_in 'record[duration]', with: attributes[:duration]

        click_on 'Сохранить', class: 'btn-success'

        video.reload

        attributes.each_key do |attr|
          next if attr == :lesson

          actual = video.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end
    end
  end
end

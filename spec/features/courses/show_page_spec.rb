# frozen_string_literal: true

require 'rails_helper'

describe 'Show course page' do
  before { move_host_to kalashnikovisme_host }

  ::Course::TEAMS.each do |team|
    before do
      create(:course, team: team, project_id: kalashnikovisme_id) do |course|
        4.times do |i|
          topic = course.topics.create attributes_for :courses_topic, position: i, project_id: kalashnikovisme_id
          6.times do |lesson_index|
            lesson = topic.lessons.create attributes_for :courses_lesson, position: lesson_index, project_id: kalashnikovisme_id
            3.times do |video_index|
              lesson.videos.create attributes_for :courses_video, position: video_index, project_id: kalashnikovisme_id
            end
            3.times do |task_index|
              lesson.tasks.create attributes_for :courses_task, position: task_index, project_id: kalashnikovisme_id
            end
          end
        end
      end
    end

    it "#{team.to_s.capitalize} team: should show all topics in a course tree" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_course = Course.last
      click_on 'Курсы'
      click_on last_course.title

      expect(page).to have_content last_course.title

      last_course.topics.each do |topic|
        url = Tramway::Admin::Engine.routes.url_helpers.record_path(topic.id, model: topic.model_name)
        within('ul.tree') do
          page.should have_selector "li a[href='#{url}']"
          page.should have_content "#{topic.model_name.human} #{topic.position} | #{topic.title}"
        end
      end
    end

    it "#{team.to_s.capitalize} team: should show all lessons in a course tree" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_course = Course.last
      click_on 'Курсы'
      click_on last_course.title

      last_course.topics.each_with_index do |topic, index|
        topic.lessons.each do |lesson|
          url = Tramway::Admin::Engine.routes.url_helpers.record_path(lesson.id, model: lesson.model_name)
          within("ul.tree > li:nth-child(#{index + 1}) > ul") do
            page.should have_selector "li a[href='#{url}']"
            page.should have_content "#{lesson.model_name.human} #{topic.position}-#{lesson.position} | #{lesson.title}"
          end
        end
      end
    end

    it "#{team.to_s.capitalize} team: should show all videos in a course tree" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_course = Course.last
      click_on 'Курсы'
      click_on last_course.title

      last_course.topics.each_with_index do |topic, index|
        topic.lessons.each_with_index do |lesson, lesson_index|
          lesson.videos.each do |video|
            video_title = "#{video.model_name.human} #{topic.position}-#{lesson.position}-#{video.position} | #{video.comments.count} comments | #{video.comments.done.count} comments done | #{video.duration}"
            url = Tramway::Admin::Engine.routes.url_helpers.record_path(video.id, model: video.model_name)
            within("ul.tree > li:nth-child(#{index + 1}) > ul") do
              within("li:nth-child(#{lesson_index + 1}) > ul") do
                page.should have_selector "li a[href='#{url}']"
                page.should have_content video_title
              end
            end
          end
        end
      end
    end

    it "#{team.to_s.capitalize} team: should show all tasks in a course tree" do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      last_course = Course.last
      click_on 'Курсы'
      click_on last_course.title

      last_course.topics.each_with_index do |topic, index|
        topic.lessons.each_with_index do |lesson, lesson_index|
          lesson.tasks.each do |task|
            task_title = "#{task.model_name.human} #{topic.position}-#{lesson.position}-#{task.position} | #{task.comments.count} comments | #{task.comments.done.count} comments done"
            url = Tramway::Admin::Engine.routes.url_helpers.record_path(task.id, model: task.model_name)
            within("ul.tree > li:nth-child(#{index + 1}) > ul") do
              within("li:nth-child(#{lesson_index + 1}) > ul") do
                page.should have_selector "li a[href='#{url}']"
                page.should have_content task_title
              end
            end
          end
        end
      end
    end
  end
end

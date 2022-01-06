# frozen_string_literal: true

require 'rails_helper'

describe 'Create comment' do
  before { move_host_to kalashnikovisme_host }
  let(:attributes) { attributes_for :courses_comment }

  describe 'Admin' do
    it 'should create comment for video' do
      count = Courses::Comment.count
      course = create :course, project_id: kalashnikovisme_id
      topic = course.topics.create! attributes_for :courses_topic
      lesson = topic.lessons.create!(**attributes_for(:courses_lesson))
      video = lesson.videos.create!(**attributes_for(:courses_video))
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on course.title
      within 'ul.tree' do
        click_on Courses::VideoDecorator.new(video).title
      end
      click_on 'Добавить комментарии'

      fill_in 'record[begin_time]', with: attributes[:begin_time]
      fill_in 'record[end_time]', with: attributes[:end_time]
      fill_in 'record[phrase]', with: attributes[:phrase]
      fill_in 'record[text]', with: attributes[:text]

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Comment.count).to eq(count + 1)

      comment = Courses::Comment.last
      attributes.each_key do |attr|
        next if attr == :associated

        actual = comment.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end

    it 'Admin: should create comment for task' do
      count = Courses::Comment.count
      course = create :course, project_id: kalashnikovisme_id
      topic = course.topics.create! attributes_for :courses_topic
      lesson = topic.lessons.create!(**attributes_for(:courses_lesson))
      task = lesson.tasks.create!(**attributes_for(:courses_task))
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on course.title
      within 'ul.tree' do
        click_on Courses::TaskDecorator.new(task).title
      end
      click_on 'Добавить комментарии'

      fill_in 'record[begin_time]', with: attributes[:begin_time]
      fill_in 'record[end_time]', with: attributes[:end_time]
      fill_in 'record[phrase]', with: attributes[:phrase]
      fill_in 'record[text]', with: attributes[:text]

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Comment.count).to eq(count + 1)

      comment = Courses::Comment.last
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

      it 'should create comment for video' do
        count = Courses::Comment.count
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create! attributes_for :courses_topic
        lesson = topic.lessons.create!(**attributes_for(:courses_lesson))
        video = lesson.videos.create!(**attributes_for(:courses_video))
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on course.title
        within 'ul.tree' do
          click_on Courses::VideoDecorator.new(video).title
        end
        click_on 'Добавить комментарии'

        fill_in 'record[begin_time]', with: attributes[:begin_time]
        fill_in 'record[end_time]', with: attributes[:end_time]
        fill_in 'record[phrase]', with: attributes[:phrase]
        fill_in 'record[text]', with: attributes[:text]

        click_on 'Сохранить', class: 'btn-success'
        expect(Courses::Comment.count).to eq(count + 1)

        comment = Courses::Comment.last
        attributes.each_key do |attr|
          next if attr == :associated

          actual = comment.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end

      it "#{team.to_s.capitalize} team: should create comment for task" do
        count = Courses::Comment.count
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create! attributes_for :courses_topic
        lesson = topic.lessons.create!(**attributes_for(:courses_lesson))
        task = lesson.tasks.create!(**attributes_for(:courses_task))
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on course.title
        within 'ul.tree' do
          click_on Courses::TaskDecorator.new(task).title
        end
        click_on 'Добавить комментарии'

        fill_in 'record[begin_time]', with: attributes[:begin_time]
        fill_in 'record[end_time]', with: attributes[:end_time]
        fill_in 'record[phrase]', with: attributes[:phrase]
        fill_in 'record[text]', with: attributes[:text]

        click_on 'Сохранить', class: 'btn-success'
        expect(Courses::Comment.count).to eq(count + 1)

        comment = Courses::Comment.last
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

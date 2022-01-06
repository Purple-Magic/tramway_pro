# frozen_string_literal: true

require 'rails_helper'

describe 'Create task' do
  before { move_host_to kalashnikovisme_host }

  it 'Admin: should create task' do
    count = Courses::Task.count
    course = create :course, project_id: kalashnikovisme_id
    topic = course.topics.create! attributes_for :courses_topic
    lesson = topic.lessons.create!(**attributes_for(:courses_lesson), topic: topic)
    visit '/admin'
    fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on 'Курсы'
    click_on course.title
    within 'ul.tree' do
      click_on "#{lesson.model_name.human} #{lesson.topic.position}-#{lesson.position} | #{lesson.title}"
    end
    click_on 'Добавить задания'

    fill_in 'record[text]', with: attributes[:text]
    fill_in 'record[position]', with: attributes[:position]
    fill_in 'record[min_time]', with: attributes[:min_time]
    fill_in 'record[max_time]', with: attributes[:max_time]

    click_on 'Сохранить', class: 'btn-success'
    expect(Courses::Task.count).to eq(count + 1)

    task = Courses::Task.last
    attributes.each_key do |attr|
      unless attr == :lesson
        actual = task.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end

  ::Course::TEAMS.each do |team|
    let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
    let(:attributes) { attributes_for :courses_task }

    it "#{team.to_s.capitalize} team: should create task" do
      count = Courses::Task.count
      course = create :course, team: team, project_id: kalashnikovisme_id
      topic = course.topics.create! attributes_for :courses_topic
      lesson = topic.lessons.create!(**attributes_for(:courses_lesson), topic: topic)
      visit '/admin'
      user.update! role: team # NOTE: we need it because of user middleware
      user.reload
      fill_in 'Email', with: user.email
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on course.title
      within 'ul.tree' do
        click_on "#{lesson.model_name.human} #{lesson.topic.position}-#{lesson.position} | #{lesson.title}"
      end
      click_on 'Добавить задания'

      fill_in 'record[text]', with: attributes[:text]
      fill_in 'record[position]', with: attributes[:position]
      fill_in 'record[min_time]', with: attributes[:min_time]
      fill_in 'record[max_time]', with: attributes[:max_time]

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Task.count).to eq(count + 1)

      task = Courses::Task.last
      attributes.each_key do |attr|
        unless attr == :lesson
          actual = task.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end
    end
  end
end

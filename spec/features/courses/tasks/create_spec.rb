# frozen_string_literal: true

require 'rails_helper'

describe 'Create task', type: :feature do
  before { move_host_to kalashnikovisme_host }
  let(:attributes) { attributes_for :courses_task }

  describe 'Admin' do
    it 'should create task' do
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

      fill_in 'record[position]', with: attributes[:position]
      fill_in 'record[min_time]', with: attributes[:min_time]
      fill_in 'record[max_time]', with: attributes[:max_time]
      fill_in_ckeditor 'record[text]', with: attributes[:text]

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Task.count).to eq(count + 1)

      task = Courses::Task.last

      assert_attributes task, attributes.except(:text)
    end
  end

  Courses::Teams::List.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }

      it 'should create task' do
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

        fill_in_ckeditor 'record[text]', with: attributes[:text]
        fill_in 'record[position]', with: attributes[:position]
        fill_in 'record[min_time]', with: attributes[:min_time]
        fill_in 'record[max_time]', with: attributes[:max_time]

        click_on 'Сохранить', class: 'btn-success'
        expect(Courses::Task.count).to eq(count + 1)

        task = Courses::Task.last

        assert_attributes task, attributes.except(:text)
      end
    end
  end
end

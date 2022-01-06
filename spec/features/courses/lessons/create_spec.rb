# frozen_string_literal: true

require 'rails_helper'

describe 'Create lesson' do
  before { move_host_to kalashnikovisme_host }
  let(:attributes) { attributes_for :courses_lesson }

  describe 'Admin' do
    it 'should create lesson' do
      count = Courses::Lesson.count
      course = create :course, project_id: kalashnikovisme_id
      topic = course.topics.create! attributes_for :courses_topic
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on course.title
      within 'ul.tree' do
        click_on "#{topic.model_name.human} #{topic.position} | #{topic.title}"
      end
      click_on 'Добавить уроки'

      fill_in 'record[title]', with: attributes[:title]
      fill_in 'record[position]', with: attributes[:position]

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Lesson.count).to eq(count + 1)

      lesson = Courses::Lesson.last
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

      it "should create lesson" do
        count = Courses::Lesson.count
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create! attributes_for :courses_topic
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on course.title
        within 'ul.tree' do
          click_on "#{topic.model_name.human} #{topic.position} | #{topic.title}"
        end
        click_on 'Добавить уроки'

        fill_in 'record[title]', with: attributes[:title]
        fill_in 'record[position]', with: attributes[:position]

        click_on 'Сохранить', class: 'btn-success'
        expect(Courses::Lesson.count).to eq(count + 1)

        lesson = Courses::Lesson.last
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

# frozen_string_literal: true

require 'rails_helper'

describe 'Create video' do
  before { move_host_to kalashnikovisme_host }
  let(:attributes) { attributes_for :courses_video }

  describe 'Admin' do
    it 'should create video' do
      count = Courses::Video.count
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
      click_on 'Добавить видео'

      fill_in_ckeditor 'record[text]', with: attributes[:text]
      fill_in 'record[position]', with: attributes[:position]
      fill_in_datepicker 'record[release_date]', with: attributes[:release_date]
      fill_in 'record[duration]', with: attributes[:duration]

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Video.count).to eq(count + 1)

      video = Courses::Video.last

      assert_attributes video, attributes.except(:text)
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }

      it 'should create video' do
        count = Courses::Video.count
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
        click_on 'Добавить видео'

        fill_in_ckeditor 'record[text]', with: attributes[:text]
        fill_in 'record[position]', with: attributes[:position]
        fill_in_datepicker 'record[release_date]', with: attributes[:release_date]
        fill_in 'record[duration]', with: attributes[:duration]

        click_on 'Сохранить', class: 'btn-success'
        expect(Courses::Video.count).to eq(count + 1)

        video = Courses::Video.last

        assert_attributes video, attributes.except(:text)
      end
    end
  end
end

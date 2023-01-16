# frozen_string_literal: true

require 'rails_helper'

describe 'Create screencast' do
  before { move_host_to kalashnikovisme_host }
  let(:attributes) { attributes_for :courses_screencast, :without_associations }

  describe 'Admin' do
    it 'should create screencast for video' do
      count = Courses::Screencast.count
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
      click_on 'Добавить скринкасты'

      fill_form :admin_courses_screencast, attributes

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Screencast.count).to eq(count + 1)

      screencast = Courses::Screencast.last
      assert_attributes screencast, attributes, additionals: { video: video }
    end
  end

  Courses::Teams::List.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }

      it "#{team.to_s.capitalize} should create screencast for video" do
        count = Courses::Screencast.count
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
        click_on 'Добавить скринкасты'

        fill_form "#{team}_courses_screencast", attributes

        click_on 'Сохранить', class: 'btn-success'
        expect(Courses::Screencast.count).to eq(count + 1)

        screencast = Courses::Screencast.last
        assert_attributes screencast, attributes, additionals: { video: video }
      end
    end
  end
end

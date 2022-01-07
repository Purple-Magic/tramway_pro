# frozen_string_literal: true

require 'rails_helper'

describe 'Edit comment page' do
  before { move_host_to kalashnikovisme_host }

  describe 'Admin' do
    let!(:comment) do
      topic = create :courses_topic,
        project_id: kalashnikovisme_id,
        course: create(:course, project_id: kalashnikovisme_id)
      lesson = create :courses_lesson, project_id: kalashnikovisme_id, topic: topic
      associated_type = Courses::Comment.associated_type.values.sample
      associated = create associated_type.underscore.gsub('/', '_'), lesson: lesson
      create :courses_comment, associated: associated, project_id: kalashnikovisme_id
    end

    it 'should set comment ready page' do
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on comment.associated.lesson.topic.course.title
      within 'ul.tree' do
        click_on Courses::CommentDecorator.new(comment).associated.title
      end
      within "tr#comments_#{comment.id}" do
        find('.btn.btn-success', match: :first, text: 'Готово').click
      end

      expect(page).to have_current_path(
        ::Tramway::Admin::Engine.routes.url_helpers.record_path(comment.associated_id, model: comment.associated_type)
      )

      comment.reload
      expect(comment.done?).to be_truthy
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }
      let!(:comment) { create :courses_comment, project_id: kalashnikovisme_id }

      it 'should show edit comment page' do
        course = create :course, team: team, project_id: kalashnikovisme_id
        topic = course.topics.create!(**attributes_for(:courses_topic))
        lesson = topic.lessons.create!(attributes_for(:courses_lesson))
        associated_type = Courses::Comment.associated_type.values.sample
        comment.update! associated: create(associated_type.underscore.gsub('/', '_'), lesson: lesson)
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on comment.associated.lesson.topic.course.title
        within 'ul.tree' do
          click_on Courses::CommentDecorator.new(comment).associated.title
        end
        within "tr#comments_#{comment.id}" do
          find('.btn.btn-success', match: :first, text: 'Готово').click
        end

        expect(page).to have_current_path(
          ::Tramway::Admin::Engine.routes.url_helpers.record_path(comment.associated_id, model: comment.associated_type)
        )

        comment.reload
        expect(comment.done?).to be_truthy
      end
    end
  end
end

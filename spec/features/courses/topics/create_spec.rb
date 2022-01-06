# frozen_string_literal: true

require 'rails_helper'

describe 'Create topic' do
  before { move_host_to kalashnikovisme_host }
  let(:attributes) { attributes_for :courses_topic }

  describe 'Admin' do
    it 'should create topic' do
      count = Courses::Topic.count
      course = create :course, project_id: kalashnikovisme_id
      visit '/admin'
      fill_in 'Email', with: "admin#{kalashnikovisme_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Курсы'
      click_on course.title
      click_on 'Добавить темы'

      fill_in 'record[title]', with: attributes[:title]
      fill_in 'record[position]', with: attributes[:position]

      click_on 'Сохранить', class: 'btn-success'
      expect(Courses::Topic.count).to eq(count + 1)

      topic = Courses::Topic.last
      attributes.each_key do |attr|
        actual = topic.send(attr)
        expecting = attributes[attr]
        expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
      end
    end
  end

  ::Course::TEAMS.each do |team|
    describe "#{team.to_s.capitalize} team" do
      let!(:user) { create :admin, password: '123456', project_id: kalashnikovisme_id }

      it " should create topic" do
        count = Courses::Topic.count
        course = create :course, team: team, project_id: kalashnikovisme_id
        visit '/admin'
        user.update! role: team # NOTE: we need it because of user middleware
        user.reload
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: '123456'
        click_on 'Войти', class: 'btn-success'

        click_on 'Курсы'
        click_on course.title
        click_on 'Добавить темы'

        fill_in 'record[title]', with: attributes[:title]
        fill_in 'record[position]', with: attributes[:position]

        click_on 'Сохранить', class: 'btn-success'
        expect(Courses::Topic.count).to eq(count + 1)

        topic = Courses::Topic.last
        attributes.each_key do |attr|
          actual = topic.send(attr)
          expecting = attributes[attr]
          expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
        end
      end
    end
  end
end

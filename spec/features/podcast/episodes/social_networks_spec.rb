# frozen_string_literal: true
# require 'rails_helper'
#
# describe 'Podcast' do
#  describe 'Episodes' do
#    describe 'Social networks' do
#      let!(:project_id) { red_magic_id }
#      let!(:podcast) { create :podcast, project_id: project_id }
#      let!(:episodes) do
#        (1..5).to_a.map do
#          create :podcast_episode, podcast: podcast, project_id: project_id
#        end
#      end
#
#      before { move_host_to red_magic_host }
#
#      it 'should return VK post' do
#        visit '/admin'
#        fill_in 'Email', with: "admin#{project_id}@email.com"
#        fill_in 'Пароль', with: '123456'
#        click_on 'Войти', class: 'btn-success'
#
#        click_on 'Подкасты'
#        click_on "Выпуск ##{episodes.last.number}"
#
#        expect(page).to have_content 'Ведущие'
#      end
#    end
#  end
# end

## frozen_string_literal: true
#
# require 'rails_helper'
#
# describe 'Index podcasts' do
#  before { move_host_to it_way_host }
#  let!(:podcasts) { create_list :podcast, 5, project_id: it_way_id }
#
#  it 'should show index podcasts page' do
#    visit '/admin'
#    fill_in 'Email', with: "admin#{it_way_id}@email.com"
#    fill_in 'Пароль', with: '123456'
#    click_on 'Войти', class: 'btn-success'
#
#    click_on 'Подкасты'
#
#    podcasts.each do |podcast|
#      expect(page).to have_content podcast.title
#    end
#  end
# end

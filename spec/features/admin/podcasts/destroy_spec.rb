# frozen_string_literal: true
## frozen_string_literal: true
#
# require 'rails_helper'
#
# describe 'Destroy podcast' do
#  before { move_host_to it_way_host }
#  before { create :podcast, project_id: it_way_id }
#
#  it 'should destroy podcast' do
#    visit '/admin'
#    fill_in 'Email', with: "admin#{it_way_id}@email.com"
#    fill_in 'Пароль', with: '123456'
#    click_on 'Войти', class: 'btn-success'
#
#    last_podcast = Podcast.last
#    click_on 'Подкасты'
#    click_on_delete_button last_podcast
#    last_podcast.reload
#
#    expect(last_podcast.removed?).to be_truthy
#  end
# end

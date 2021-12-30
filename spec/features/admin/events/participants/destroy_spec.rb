# frozen_string_literal: true

require 'rails_helper'

describe 'Destroy participant' do
  before { move_host_to it_way_host }
  before { create :participant, project_id: it_way_id }

  it 'should destroy participant' do
    count = ::Tramway::Event::Participant.count
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_participant = Tramway::Event::Participant.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    click_on_delete_button last_participant

    expect(::Tramway::Event::Participant.count).to be < count
  end
end

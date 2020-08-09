# frozen_string_literal: true

require 'rails_helper'

describe 'Destroy participant' do
  before { move_host_to it_way_host }
  before { create :participant, project_id: it_way_id }

  it 'should destroy participant' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_participant = Tramway::Event::Participant.active.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    click_on_delete_button last_participant
    last_participant.reload

    expect(last_participant.removed?).to be_truthy
  end
end

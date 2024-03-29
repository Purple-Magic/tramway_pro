# frozen_string_literal: true

require 'rails_helper'

describe 'Edit participant page' do
  before { move_host_to it_way_host }
  before { create :participant, project_id: it_way_id }

  it 'should show edit participant page' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    participant = Tramway::Event::Participant.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    click_on_table_item "#{participant.values['Фамилия']} #{participant.values['Имя']}"
    find('.btn.btn-warning', match: :first).click

    expect(page).to have_field 'record[Фамилия]', with: participant.values['Фамилия']
    expect(page).to have_field 'record[Имя]', with: participant.values['Имя']
    expect(page).to have_field 'record[Место учёбы / работы]', with: participant.values['Место учёбы / работы']
    expect(page).to have_field 'record[Номер телефона]', with: participant.values['Номер телефона']
    expect(page).to have_field 'record[Email]', with: participant.values['Email']
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'Show participant' do
  before { set_host it_way_host }
  before { create :participant, project_id: it_way_id }

  it 'should show participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    participant = create :participant, project_id: it_way_id
    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    title = "#{participant.values['Фамилия']} #{participant.values['Имя']}"
    click_on_table_item title

    expect(page).to have_content title
  end
end

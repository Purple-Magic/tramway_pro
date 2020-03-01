# frozen_string_literal: true

require 'rails_helper'

describe 'Update participant' do
  before { set_host it_way_host }
  let!(:attributes) { attributes_for :participant_admin_attributes }
  before { create :participant, project_id: it_way_id }

  it 'should update participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    participant = Tramway::Event::Participant.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    title = "#{participant.values['Фамилия']} #{participant.values['Имя']}"
    click_on_table_item title
    find('.btn.btn-warning', match: :first).click
    fill_in 'record[Фамилия]', with: attributes[:'Фамилия']
    fill_in 'record[Имя]', with: attributes[:'Имя']
    fill_in 'record[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
    fill_in 'record[Номер телефона]', with: attributes[:'Номер телефона']
    fill_in 'record[Email]', with: attributes[:Email]

    click_on 'Сохранить', class: 'btn-success'
    participant.reload
    attributes.each do |pair|
      actual = participant.values[pair[0].to_s]
      expecting = pair[1]
      expecting = expecting.strftime('%d.%m.%Y') if expecting.is_a? DateTime
      expect(actual).to eq(expecting), problem_with(attr: pair[0], expecting: expecting, actual: actual)
    end
  end

  it 'should show participant admin page' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    participant = Tramway::Event::Participant.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    click_on_table_item "#{participant.values['Фамилия']} #{participant.values['Имя']}"
    find('.btn.btn-warning', match: :first).click
    fill_in 'record[Фамилия]', with: attributes[:'Фамилия']
    fill_in 'record[Имя]', with: attributes[:'Имя']
    fill_in 'record[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
    fill_in 'record[Номер телефона]', with: attributes[:'Номер телефона']
    fill_in 'record[Email]', with: attributes[:Email]

    click_on 'Сохранить', class: 'btn-success'

    participant.reload
    expect(page).to have_content(
      "#{participant.values['Фамилия']} #{participant.values['Имя']}"
    )
  end
end

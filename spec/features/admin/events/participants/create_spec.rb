# frozen_string_literal: true

require 'rails_helper'

describe 'Create participant' do
  before { move_host_to it_way_host }
  let!(:attributes) { attributes_for :participant_admin_attributes }
  let!(:event) { create :event, project_id: it_way_id }

  it 'should create participant' do
    count = Tramway::Event::Participant.count
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    find('.btn.btn-primary', match: :first).click
    select event.title, from: 'record[event]'

    click_on 'Сохранить', class: 'btn-success'

    find('.btn.btn-warning', match: :first).click
    fill_in 'record[Фамилия]', with: attributes[:Фамилия]
    fill_in 'record[Имя]', with: attributes[:Имя]
    fill_in 'record[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
    fill_in 'record[Номер телефона]', with: attributes[:'Номер телефона']
    fill_in 'record[Email]', with: attributes[:Email]

    click_on 'Сохранить', class: 'btn-success'

    expect(Tramway::Event::Participant.count).to eq(count + 1)
    participant = Tramway::Event::Participant.last
    attributes.each do |(key, value)|
      actual = participant.values[key.to_s]
      expecting = value
      expecting = expecting.strftime('%d.%m.%Y') if expecting.is_a? DateTime
      expect(actual).to eq(expecting), problem_with(attr: key, expecting: expecting, actual: actual)
    end
  end

  it 'should show participant admin page' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Участники'
    find('.btn.btn-primary', match: :first).click
    select event.title, from: 'record[event]'

    click_on 'Сохранить', class: 'btn-success'

    find('.btn.btn-warning', match: :first).click
    fill_in 'record[Фамилия]', with: attributes[:Фамилия]
    fill_in 'record[Имя]', with: attributes[:Имя]
    fill_in 'record[Место учёбы / работы]', with: attributes[:'Место учёбы / работы']
    fill_in 'record[Номер телефона]', with: attributes[:'Номер телефона']
    fill_in 'record[Email]', with: attributes[:Email]

    click_on 'Сохранить', class: 'btn-success'

    expect(page).to have_content "#{attributes[:Фамилия]} #{attributes[:Имя]} | Участник"
  end
end

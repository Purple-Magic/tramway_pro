# frozen_string_literal: true
## frozen_string_literal: true
#
# require 'rails_helper'
#
# describe 'Mandatory form fields' do
#  before { move_host_to it_way_host }
#  let!(:attributes) { attributes_for :event_admin_attributes }
#
#  it 'should show mandatory form fields after creating an event' do
#    visit '/admin'
#    fill_in 'Email', with: "admin#{it_way_id}@email.com"
#    fill_in 'Пароль', with: '123456'
#    click_on 'Войти', class: 'btn-success'
#
#    click_on_dropdown 'Организация мероприятий'
#    click_on 'Мероприятия'
#    find('.btn.btn-primary', match: :first).click
#    fill_in 'record[title]', with: attributes[:title]
#    fill_in 'record[begin_date]', with: attributes[:begin_date]
#    fill_in 'record[end_date]', with: attributes[:end_date]
#    fill_in 'record[request_collecting_begin_date]', with: attributes[:request_collecting_begin_date]
#    fill_in 'record[request_collecting_end_date]', with: attributes[:request_collecting_end_date]
#
#    click_on 'Сохранить', class: 'btn-success'
#    event = Tramway::Event::Event.last
#    click_on_dropdown 'Организация мероприятий'
#    click_on 'Мероприятия'
#    click_on event.title
#
#    expect(page).to have_content 'Фамилия'
#    expect(page).to have_content 'Имя'
#    expect(page).to have_content 'Место учёбы / работы'
#    expect(page).to have_content 'Email'
#    expect(page).to have_content 'Номер телефона'
#  end
#
#  it 'should create exaclty needed mandatory form fields after creating an event' do
#    visit '/admin'
#    fill_in 'Email', with: "admin#{it_way_id}@email.com"
#    fill_in 'Пароль', with: '123456'
#    click_on 'Войти', class: 'btn-success'
#
#    click_on_dropdown 'Организация мероприятий'
#    click_on 'Мероприятия'
#    find('.btn.btn-primary', match: :first).click
#    fill_in 'record[title]', with: attributes[:title]
#    fill_in 'record[begin_date]', with: attributes[:begin_date]
#    fill_in 'record[end_date]', with: attributes[:end_date]
#    fill_in 'record[request_collecting_begin_date]', with: attributes[:request_collecting_begin_date]
#    fill_in 'record[request_collecting_end_date]', with: attributes[:request_collecting_end_date]
#
#    click_on 'Сохранить', class: 'btn-success'
#    event = Tramway::Event::Event.last
#
#    expect(event.participant_form_fields.where(title: 'Фамилия')).not_to be_empty
#    expect(event.participant_form_fields.where(title: 'Имя')).not_to be_empty
#    expect(event.participant_form_fields.where(title: 'Место учёбы / работы')).not_to be_empty
#    expect(event.participant_form_fields.where(title: 'Email')).not_to be_empty
#    expect(event.participant_form_fields.where(title: 'Номер телефона')).not_to be_empty
#  end
# end

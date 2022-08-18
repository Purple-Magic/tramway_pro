# frozen_string_literal: true

require 'rails_helper'

describe 'Mandatory actions' do
  before { move_host_to it_way_host }
  let!(:attributes) { attributes_for :event_admin_attributes }

  it 'should show mandatory actions after creating an event' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    find('.btn.btn-primary', match: :first).click
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[begin_date]', with: attributes[:begin_date]
    fill_in 'record[end_date]', with: attributes[:end_date]
    fill_in 'record[request_collecting_begin_date]', with: attributes[:request_collecting_begin_date]
    fill_in 'record[request_collecting_end_date]', with: attributes[:request_collecting_end_date]

    click_on 'Сохранить', class: 'btn-success'
    event = Tramway::Event::Event.last
    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title

    expect(page).to have_content 'Определение места проведения мероприятия'
    expect(page).to have_content 'Сделать рассылку по местным пабликам о мероприятии'
    expect(page).to have_content 'Развесить постеры о мероприятии'
    expect(page).to have_content 'Отправка информационных писем в учебные заведения'
    expect(page).to have_content 'Подтверждение участия контент-мейкеров'
    expect(page).to have_content 'Найти ведущего мероприятия'
    expect(page).to have_content 'Проверка помещение на техническое соответствие'
    expect(page).to have_content 'Найти фотографа'
    expect(page).to have_content 'Найти видеографа'
    expect(page).to have_content 'Публикация фото-отчёта'
    expect(page).to have_content 'Публикация видео-отчёта'
  end

  it 'should create exaclty needed mandatory actions after creating an event' do
    visit '/admin'
    fill_in 'Email', with: "admin#{it_way_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    find('.btn.btn-primary', match: :first).click
    fill_in 'record[title]', with: attributes[:title]
    fill_in 'record[begin_date]', with: attributes[:begin_date]
    fill_in 'record[end_date]', with: attributes[:end_date]
    fill_in 'record[request_collecting_begin_date]', with: attributes[:request_collecting_begin_date]
    fill_in 'record[request_collecting_end_date]', with: attributes[:request_collecting_end_date]

    click_on 'Сохранить', class: 'btn-success'
    event = Tramway::Event::Event.last

    expect(event.actions.where(title: 'Определение места проведения мероприятия')).not_to be_empty
    expect(event.actions.where(title: 'Сделать рассылку по местным пабликам о мероприятии')).not_to be_empty
    expect(event.actions.where(title: 'Развесить постеры о мероприятии')).not_to be_empty
    expect(event.actions.where(title: 'Отправка информационных писем в учебные заведения')).not_to be_empty
    expect(event.actions.where(title: 'Подтверждение участия контент-мейкеров')).not_to be_empty
    expect(event.actions.where(title: 'Найти ведущего мероприятия')).not_to be_empty
    expect(event.actions.where(title: 'Проверка помещение на техническое соответствие')).not_to be_empty
    expect(event.actions.where(title: 'Найти фотографа')).not_to be_empty
    expect(event.actions.where(title: 'Найти видеографа')).not_to be_empty
    expect(event.actions.where(title: 'Публикация фото-отчёта')).not_to be_empty
    expect(event.actions.where(title: 'Публикация видео-отчёта')).not_to be_empty
  end
end

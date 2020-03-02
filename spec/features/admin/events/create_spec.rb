# frozen_string_literal: true

require 'rails_helper'

describe 'Create event' do
  before { move_host_to it_way_host }
  let!(:attributes) { attributes_for :event_admin_attributes }

  it 'should create event' do
    count = Tramway::Event::Event.count
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
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
    expect(Tramway::Event::Event.count).to eq(count + 1)
    event = Tramway::Event::Event.last
    attributes.keys.each do |attr|
      actual = event.send(attr)
      expecting = attributes[attr]
      if attr.in? %i[begin_date end_date request_collecting_end_date request_collecting_begin_date]
        actual = actual.to_datetime
      end
      case actual.class.to_s
      when 'NilClass'
        expect(actual).not_to be_empty, "#{attr} is empty"
      when 'Enumerize::Value'
        expect(actual).not_to be_empty, "#{attr} is empty"
        actual = actual.text
      end
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end

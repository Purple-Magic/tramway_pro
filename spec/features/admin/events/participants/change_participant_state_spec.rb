# frozen_string_literal: true

require 'rails_helper'

describe 'Change participant state' do
  before { move_host_to it_way_host }
  let!(:event) { create :event, project_id: it_way_id }
  let!(:participant) { create :participant, event: event, project_id: it_way_id }

  it 'should pre_approve participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title
    click_on 'Открыть'
    click_on_tab 'Необработанные'
    click_on 'Предварительно подтвердить'

    participant.reload

    expect(participant.prev_approved?).to be_truthy
  end

  it 'should wait for decision participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title
    click_on 'Открыть'
    click_on_tab 'Необработанные'
    click_on 'Ожидать ответа'

    participant.reload

    expect(participant.waiting?).to be_truthy
  end

  it 'should reserve participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title
    click_on 'Открыть'
    click_on_tab 'Необработанные'
    click_on 'Отправить в резерв'

    participant.reload

    expect(participant.reserved?).to be_truthy
  end

  it 'should reject participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title
    click_on 'Открыть'
    click_on_tab 'Необработанные'
    click_on 'Отклонить'

    participant.reload

    expect(participant.rejected?).to be_truthy
  end

  it 'should approve participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title
    click_on 'Открыть'
    click_on_tab 'Необработанные'
    click_on 'Прибыл(а)'

    participant.reload

    expect(participant.approved?).to be_truthy
  end

  it 'should not_got_answer participant' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on_dropdown 'Организация мероприятий'
    click_on 'Мероприятия'
    click_on event.title
    click_on 'Открыть'
    click_on_tab 'Необработанные'
    click_on 'Связаться не удалось'

    participant.reload

    expect(participant.without_answer?).to be_truthy
  end
end

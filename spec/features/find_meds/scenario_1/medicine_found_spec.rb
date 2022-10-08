# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  context 'Scenario 1' do
    describe 'Medicine Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Финлепсин Ретард' }
      let(:message_3) { build :telegram_message, text: 'NOVARTIS FARMA, S.p.A.' }
      let(:message_4) { build :telegram_message, text: 'Таб.пролонгированного действия' }
      let(:message_5) { build :telegram_message, text: 'carbamazepine концентрация 400 мг' }

      it 'search medicine by name' do
        find_meds_airtable_stub_request table: :drugs
        find_meds_airtable_stub_request table: :medicines
        find_meds_airtable_stub_request table: :companies
        find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7P'
        find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7L'
        find_meds_airtable_stub_request table: :concentrations
        find_meds_airtable_stub_request table: :active_components

        stub_1 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Убедитесь, что название написано правильно'
        }

        bot_run :find_meds, bot_record: bot_record, message: message_1, chat: chat, message_object: message_object

        expect(stub_1).to have_been_requested

        stub_2 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Мы нашли лекараство. Лекарством какой фирмы вы пользуетесь?',
          reply_markup: reply_markup(
            [
              'NOVARTIS FARMA, S.p.A.',
              'МОСКОВСКИЙ ЭНДОКРИННЫЙ ЗАВОД, ФГУП'
            ],
            [
              'В начало',
              'Нужной фирмы нет'
            ]
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_2, chat: chat, message_object: message_object

        expect(stub_2).to have_been_requested

        stub_3 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Какой лекарственной формулой вы пользуетесь?',
          reply_markup: reply_markup(
            [
              'Таб.пролонгированного действия'
            ],
            [
              'В начало',
              'Нужной формы нет'
            ]
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_3, chat: chat, message_object: message_object

        expect(stub_3).to have_been_requested

        stub_4 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Какая концентрация действующего вещества carbamazepine вам нужна?',
          reply_markup: reply_markup(
            [
              '400 мг'
            ],
            [
              'В начало',
              'Нужной концентрации нет'
            ]
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_4, chat: chat, message_object: message_object

        expect(stub_4).to have_been_requested

        stub_5 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Это то лекарство, которое вы используете? Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 400 мг',
          reply_markup: reply_markup(
            [
              'Да',
              'Нет'
            ]
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_5, chat: chat, message_object: message_object

        expect(stub_5).to have_been_requested
      end
    end
  end
end

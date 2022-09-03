# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  context 'Scenario 2' do
    describe 'Medicine Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Конвилепт' }
      let(:message_3) { build :telegram_message, text: 'levetiracetam' }

      it 'search medicine by component' do
        find_meds_airtable_stub_request table: :drugs
        find_meds_airtable_stub_request table: :active_components
        find_meds_airtable_stub_request table: :medicines

        stub_1 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Введите название лекарства на кириллице'
        }

        bot_run :find_meds, bot_record: bot_record, message: message_1, chat: chat, message_object: message_object

        expect(stub_1).to have_been_requested

        stub_2 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Мы не знаем о таком лекарстве. Пожалуйста, проверьте правописание или введите названия действующих веществ на латинице через запятую.'
        }

        bot_run :find_meds, bot_record: bot_record, message: message_2, chat: chat, message_object: message_object

        expect(stub_2).to have_been_requested

        stub_3 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Какая форма вам нужна?',
          reply_markup: reply_markup(
            [
              'Таб.пролонгированного действия',
              'Раствор для приема внутрь'
            ],
            [
              'Назад'
            ] 
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_3, chat: chat, message_object: message_object

        expect(stub_3).to have_been_requested

        stub_4 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Какая концентрация вам нужна?',
          reply_markup: reply_markup(
            [
              '500мг',
              '400мг',
            ],
            [
              'Другая',
              'Назад'
            ] 
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_3, chat: chat, message_object: message_object

        expect(stub_4).to have_been_requested
      end
    end
  end
end
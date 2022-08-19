# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  context 'Scenario 1' do
    describe 'Medicine Not Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Валидол' }

      it 'returns invitation to type a name' do
        airtable_stub1 = airtable_collection_stub_request(
          base: ::BotTelegram::FindMedsBot::Tables::ApplicationTable.base_key,
          table: :names
        )

        airtable_stub2 = airtable_collection_stub_request(
          base: ::BotTelegram::FindMedsBot::Tables::ApplicationTable.base_key,
          table: :active_components
        )

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
        expect(airtable_stub1).to have_been_requested
        expect(airtable_stub2).to have_been_requested
      end
    end
  end
end

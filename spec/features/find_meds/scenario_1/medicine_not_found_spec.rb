# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  context 'Scenario 1' do
    describe 'Medicine Not Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Тегерол' }

      it 'returns not found message' do
        find_meds_airtable_stub_request table: :drugs

        stub_1 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Убедитесь, что название написано правильно'
        }

        bot_run :find_meds, bot_record: bot_record, message: message_1, chat: chat, message_object: message_object

        expect(stub_1).to have_been_requested

        stub_2 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Увы, мы пока не знаем о таком лекарстве, позже мы добавим возможность искать и по действующим веществам, чтобы можно было найти дженерики даже если мы не знаем о том лекарстве, которое используете вы',
          reply_markup: reply_markup(
            ['В начало']
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_2, chat: chat, message_object: message_object

        expect(stub_2).to have_been_requested
      end
    end
  end
end

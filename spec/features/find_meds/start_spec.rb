# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  describe 'Start' do
    let(:message) { build :start_telegram_message }

    it 'returns welcome message' do
      stub = send_message_stub_request body: {
        chat_id: chat.telegram_chat_id,
        text: 'Привет, я бот по поиску лекарств и дальше тут я рассказываю, как мной пользоваться',
        reply_markup: reply_markup([
                                     'Поиск лекарств', 'О проекте'
                                   ])
      }

      bot_run :find_meds, bot_record: bot_record, message: message, chat: chat, message_object: message_object

      expect(stub).to have_been_requested
    end
  end
end

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
          'Поиск лекарств'
        ])
      }

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::FindMedsBot::Scenario.new(
          message: message,
          bot: bot,
          bot_record: bot_record,
          chat: chat,
          message_object: message_object,
          user: message_object.user
        ).run
      end

      expect(stub).to have_been_requested
    end
  end 

  describe 'Find medicine button' do
    let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
    let(:message_2) { build :telegram_message, text: 'Финлепсин Ретард' }

    it 'returns invitation to type a name' do
      stub_1 = send_message_stub_request body: {
        chat_id: chat.telegram_chat_id,
        text: 'Введите название лекарства на кириллице'
      }

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::FindMedsBot::Scenario.new(
          message: message_1,
          bot: bot,
          bot_record: bot_record,
          chat: chat,
          message_object: message_object,
          user: message_object.user
        ).run
      end

      expect(stub_1).to have_been_requested

      stub_2 = send_message_stub_request body: {
        chat_id: chat.telegram_chat_id,
        text: 'Финлепсин Ретард есть в нашей базе данных. Выберите нужную вам концентрацию',
        reply_markup: reply_markup(
          ['200', '400'], ['Другая', 'Назад']
        )
      }

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::FindMedsBot::Scenario.new(
          message: message_2,
          bot: bot,
          bot_record: bot_record,
          chat: chat,
          message_object: message_object,
          user: message_object.user
        ).run
      end

      expect(stub_2).to have_been_requested
    end
  end
end
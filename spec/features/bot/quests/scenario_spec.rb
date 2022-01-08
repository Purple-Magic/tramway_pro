require 'rails_helper'

describe 'BotTelegram::Scenario' do
  let(:bot_record) { create :quest_bot }

  describe '/start' do
    let(:start_message) { build :telegram_message, text: '/start' }

    describe 'Without a next step' do
      let!(:start_step) { create :start_scenario_step, bot: bot_record }

      it 'sends correct message' do
        send_message_stub_request body: {
          chat_id: start_message.chat.id,
          text: bot_record.start_step.text,
          parse_mode: 'markdown'
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::Scenario.run start_message, bot, bot_record
        end
      end
    end

    describe 'With a next step' do
      let!(:start_step) { create :start_scenario_step_with_next_step, bot: bot_record }

      it 'waits until next step message' do
        send_message_stub_request body: {
          chat_id: start_message.chat.id,
          text: bot_record.start_step.text,
          parse_mode: 'markdown'
        }
        send_message_stub_request body: {
          chat_id: start_message.chat.id,
          text: bot_record.start_step.next_step.text,
          reply_markup: reply_markup(['Подсказка']),
          parse_mode: 'markdown'
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::Scenario.run start_message, bot, bot_record
        end
      end
    end
  end

  describe 'Type answer' do
    describe 'After start message' do
      let(:user_message) do
        build(:telegram_message, text: bot_record.start_step.text)
      end

      it 'sends correct answer' do
        send_message_stub_request body: {
          chat_id: user_message.chat.id,
          text: bot_record.steps.select { |s| s.type_answer? }.first.text
        }
      end
    end
  end
end

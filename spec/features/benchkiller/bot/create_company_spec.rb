# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::BenchkillerBot' do
  describe 'Create company' do
    let!(:bot_record) { create :benchkiller_bot }
    let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
    let(:message_object) { create :bot_telegram_message }
    let!(:callback_query) { build :create_company_telegram_callback_query }

    describe 'CallbackQuery' do
      it 'returns success message' do
        stub = send_markdown_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:message]
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
            message: callback_query,
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

    describe 'Creating company' do
      let(:company_name) do
        attributes_for(:benchkiller_company)[:title]
      end

      let(:telegram_message) do
        build :telegram_message, text: company_name
      end

      let!(:count) do
        Benchkiller::Company.count
      end

      before do
        send_markdown_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:message]
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
            message: callback_query,
            bot: bot,
            bot_record: bot_record,
            chat: chat,
            message_object: message_object,
            user: message_object.user
          ).run
        end

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
            message: telegram_message,
            bot: bot,
            bot_record: bot_record,
            chat: chat,
            message_object: message_object,
            user: message_object.user
          ).run
        end
      end

      it 'creates company' do
        expect(Benchkiller::Company.count).to eq count + 1
      end

      it 'sets company name' do
        expect(Benchkiller::Company.last.title).to eq company_name
      end
    end
  end
end

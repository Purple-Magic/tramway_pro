# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::BenchkillerBot' do
  let!(:bot_record) { create :benchkiller_bot }

  describe '/start' do
    let!(:start_message) { build :telegram_message, text: '/start' }
    let(:message_object) { create :bot_telegram_message }
    let(:chat) { create :bot_telegram_private_chat, bot: bot_record }

    describe 'New user' do
      it 'returns create company button' do
        stub = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: benchkiller_i18n_scope(:start, :new_user_text),
          reply_markup: reply_markup(
            ['Создать компанию']
          )
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
            message: start_message,
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

    describe 'Existing company' do
      let!(:user) { create :benchkiller_user, telegram_user: message_object.user, password: '123' }

      before do
        company = create :benchkiller_company
        company.users << user
        company.save!
      end

      it 'returns menu' do
        stub = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: benchkiller_i18n_scope(:start, :text),
          reply_markup: reply_markup(
            ['Карточка компании', 'Сгенерировать пароль'],
            ['Изменить карточку', 'Управление подпиской']
          )
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
            message: start_message,
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
  end
end

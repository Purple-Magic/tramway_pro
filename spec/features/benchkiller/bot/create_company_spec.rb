# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::BenchkillerBot' do
  describe 'Create company' do
    let!(:bot_record) { create_benchkiller_bot }
    let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
    let(:message_object) { create :bot_telegram_message }
    let!(:message) { build :create_company_telegram_message }

    describe 'CallbackQuery' do
      it 'returns success message' do
        stub = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:message]
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
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

    describe 'Creating company' do
      let(:company_name) do
        attributes_for(:benchkiller_company)[:title].tap do |company_name|
          send_message_stub_request body: {
            chat_id: BotTelegram::BenchkillerBot::ADMIN_COMPANIES_CHAT_ID,
            text: "Новая компания #{company_name}. Пользователь пока заполняет данные."
          }
        end
      end

      let(:telegram_message) do
        build :telegram_message, text: company_name
      end

      let!(:count) do
        Benchkiller::Company.count
      end

      before do
        send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:message]
        }

        send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: benchkiller_i18n_scope(:create_company, :success, title: company_name),
          reply_markup: reply_markup(
            ['Название компании', 'Телефон'],
            ['Сайт', 'Расположение компании'],
            ['Портфолио', 'Регионы сотрудничества', 'Регионы-исключения'],
            %w[Почта Назад]
          )
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
            message: message,
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

    describe 'Does not create company with the same name' do
      let!(:company_name) do
        company_name = generate :company_name
        send_message_stub_request body: {
          chat_id: BotTelegram::BenchkillerBot::ADMIN_COMPANIES_CHAT_ID,
          text: "Новая компания #{company_name}. Пользователь пока заполняет данные."
        }
        create(:benchkiller_company, title: company_name).title
      end

      let(:telegram_message) do
        build :telegram_message, text: company_name
      end

      let!(:count) do
        Benchkiller::Company.count
      end

      before do
        send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:message]
        }

        send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Название компании уже существует'
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::BenchkillerBot::Scenario.new(
            message: message,
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
        expect(Benchkiller::Company.count).to eq count
      end
    end
  end
end

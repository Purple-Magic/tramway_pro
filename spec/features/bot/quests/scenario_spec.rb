# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::Scenario' do
  let!(:user) { BotTelegram::User.last || create(:bot_telegram_user) }

  before do
    move_host_to benchkiller_host
  end

  describe 'Features' do
    let!(:bot_record) { create :bot_with_start_step }

    describe '/start' do
      let!(:start_message) { build :telegram_message, text: '/start' }

      describe 'Without a next step' do
        it 'sends correct message' do
          create :start_scenario_step, bot: bot_record
          stub = send_markdown_message_stub_request body: {
            chat_id: start_message.chat.id,
            text: bot_record.start_step.text
          }

          Telegram::Bot::Client.run(bot_record.token) do |bot|
            BotTelegram::Scenario.run start_message, bot, bot_record
          end

          expect(stub).to have_been_requested
        end
      end

      describe 'With a next step' do
        let!(:start_step) { create :start_scenario_step_with_next_step, bot: bot_record }

        it 'waits until next step message' do
          stub = send_markdown_message_stub_request body: {
            chat_id: start_message.chat.id,
            text: bot_record.start_step.text
          }
          next_step_stub = send_markdown_message_stub_request body: {
            chat_id: start_message.chat.id,
            text: bot_record.start_step.next_step.text,
            reply_markup: reply_markup(['Подсказка'])
          }

          Telegram::Bot::Client.run(bot_record.token) do |bot|
            BotTelegram::Scenario.run start_message, bot, bot_record
          end

          expect(stub).to have_been_requested
          expect(next_step_stub).to have_been_requested
        end
      end
    end

    describe 'Type answer' do
      let!(:type_answer_step) do
        create(:type_answer_scenario_step, bot: bot_record).tap do |current_step|
          create :bot_telegram_scenario_process_record, user: user, step: current_step
        end
      end
      let!(:sample_answer) { type_answer_step.options.except('подсказка').keys.sample }
      let!(:user_message) do
        build(:telegram_message, text: sample_answer)
      end

      it 'sends correct answer' do
        step_by_answer = type_answer_step.step_by answer: sample_answer
        stub = send_markdown_message_stub_request body: {
          chat_id: user_message.chat.id,
          text: step_by_answer.text
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::Scenario.run user_message, bot, bot_record
        end

        expect(stub).to have_been_requested
      end
    end
  end

  describe 'Full scenario' do
    let!(:bot_record) { create :quest_bot }

    it 'passed the whole quest' do
      chat = build :telegram_chat
      start_message = build :telegram_message, text: '/start', chat: chat

      stub = send_markdown_message_stub_request body: {
        chat_id: start_message.chat.id,
        text: bot_record.start_step.text
      }

      next_stub = send_markdown_message_stub_request body: {
        chat_id: start_message.chat.id,
        text: bot_record.start_step.next_step.text,
        reply_markup: reply_markup(['Подсказка'])
      }

      send_markdown_message_stub_request body: {
        chat_id: start_message.chat.id,
        text: 'К сожалению, я не знаю, что на это ответить',
        reply_markup: reply_markup(['Подсказка'])
      }

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::Scenario.run start_message, bot, bot_record
      end
      expect(stub).to have_been_requested
      expect(next_stub).to have_been_requested
    end
  end
end

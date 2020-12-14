require_relative './messages_manager'
require_relative './info'

module BotTelegram
  module Scenario
    class << self
      include ::BotTelegram::MessagesManager
      include ::BotTelegram::Info

      def run(message_from_telegram, bot, scenario:, error_message:)
        bot_record = Bot.find_by name: scenario
        user = user_from message_from_telegram
        if message_from_telegram.text == '/start'
          current_step = bot_record.steps.find_by(name: :start)
          send_step_message current_step, bot, message_from_telegram
        else
          current_step = user.progress_records.joins(:step).where('bot_telegram_user_id = ? AND bot_telegram_scenario_steps.bot_id = ?', user.id, bot_record.id).last.step
          if current_step.present? && current_step.continue?
            next_step = find_next_step current_step, message_from_telegram
            if next_step.present?
              send_step_message next_step, bot, message_from_telegram
            else
              message_to_user bot, error_message, message_from_telegram
            end
          end
        end
      end

      def send_step_message(current_step, bot, message_from_telegram)
        message_to_user bot, current_step, message_from_telegram
        BotTelegram::Scenario::ProgressRecord.create!(
          bot_telegram_user_id: user_from(message_from_telegram).id,
          bot_telegram_scenario_step_id: current_step.id
        )
        if current_step.delay.present? && current_step.delay != 0
          sleep current_step.delay
          next_step = find_next_step current_step, message_from_telegram
          send_step_message next_step, bot, message_from_telegram
        end
      end

      def find_next_step(current_step, message_from_telegram)
        next_step = BotTelegram::Scenario::Step.find_by name: current_step.options[message_from_telegram.text]
        next_step = BotTelegram::Scenario::Step.find_by name: current_step.options['next'] unless next_step.present?
        next_step
      end
    end
  end
end

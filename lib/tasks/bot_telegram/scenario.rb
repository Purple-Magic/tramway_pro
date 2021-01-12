require_relative './messages_manager'
require_relative './info'

module BotTelegram
  module Scenario
    class << self
      include ::BotTelegram::MessagesManager
      include ::BotTelegram::Info

      def run(message_from_telegram, bot, bot_record)
        user = user_from message_from_telegram
        if message_from_telegram.text == '/start'
          current_step = bot_record.steps.find_by(name: :start)
          send_step_message current_step, bot, message_from_telegram, bot_record
        else
          current_step = user.progress_records.joins(:step).where('bot_telegram_user_id = ? AND bot_telegram_scenario_steps.bot_id = ?', user.id, bot_record.id).last&.step
          if current_step.present? && current_step.continue?
            next_step = find_next_step current_step, message_from_telegram, bot_record
            if next_step.present?
              send_step_message next_step, bot, message_from_telegram, bot_record
            else
              error = bot_record.options['standard_error'] || 'К сожалению, я не знаю, что на это ответить'
              message_to_user bot, error, message_from_telegram
            end
          end
        end
      end

      def send_step_message(current_step, bot, message_from_telegram, bot_record)
        message_to_user bot, current_step, message_from_telegram
        BotTelegram::Scenario::ProgressRecord.create!(
          bot_telegram_user_id: user_from(message_from_telegram).id,
          bot_telegram_scenario_step_id: current_step.id,
          project_id: project.id
        )
        if current_step.delay.present? && current_step.delay != 0
          next_step = find_next_step current_step, message_from_telegram, bot_record
          if next_step.present?
            sleep current_step.delay
            send_step_message next_step, bot, message_from_telegram, bot_record
          end
        end
      end

      def find_next_step(current_step, message_from_telegram, bot)
        next_step = message_from_telegram.text.present? && BotTelegram::Scenario::Step.find_by(name: current_step.options[message_from_telegram.text.downcase], bot_id: bot.id)
        next_step = BotTelegram::Scenario::Step.find_by name: current_step.options['next'], bot_id: bot.id unless next_step.present?
        next_step
      end

      CURRENT_PURPLE_MAGIC_PROJECT_ID = 7

      def project
        Project.find CURRENT_PURPLE_MAGIC_PROJECT_ID
      end
    end
  end
end

require_relative '../bot_telegram/messages_manager'
require_relative '../bot_telegram/info'

module RSM
  module ProjectOffice
    class << self
      include ::BotTelegram::MessagesManager
      include ::BotTelegram::Info

      def scenario(message_from_telegram, bot)
        bot_record = Bot.find_by name: 'Проектный офис РСМ'
        user = user_from message_from_telegram
        current_step = user.progress_records.joins(:step).where('bot_telegram_user_id = ? AND bot_telegram_scenario_steps.bot_id = ?', user.id, bot_record.id).last.step
        if current_step.present?
          if current_step.continue?
            next_step = find_next_step current_step, message_from_telegram
            if next_step.present?
              message_to_user bot, next_step, message_from_telegram
              BotTelegram::Scenario::ProgressRecord.create!(
                bot_telegram_user_id: user_from(message_from_telegram).id,
                bot_telegram_scenario_step_id: next_step.id
              )
              if next_step.delay.present? && next_step.delay != 0
                sleep next_step.delay
                scenario message_from_telegram, bot
              end
            else
              message_to_user bot, 'Используйте встроенную клавиатуру, пожалуйста', message_from_telegram
            end
          else
            step = BotTelegram::Scenario::Step.find_by name: :start
            message_to_user bot, step.text, message_from_telegram
            BotTelegram::Scenario::ProgressRecord.create!(
              bot_telegram_user_id: user_from(message_from_telegram).id,
              bot_telegram_scenario_step_id: step.id
            )
            if step.delay.present? && step.delay != 0
              sleep step.delay
              scenario message_from_telegram, bot
            end
          end
        end
      end

      def find_next_step(current_step, message_from_telegram)
        binding.pry
        next_step = BotTelegram::Scenario::Step.find_by name: current_step.options[message_from_telegram.text]
        next_step = BotTelegram::Scenario::Step.find_by name: current_step.options['next'] unless next_step.present?
        next_step
      end
    end
  end
end

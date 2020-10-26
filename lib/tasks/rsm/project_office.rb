module RSM
  module ProjectOffice
    class << self
      include BotTelegram::MessagesManager
      include BotTelegram::Info

      def scenario(message_from_telegram, bot)
        bot_record = Bot.find_by name: 'Проектный офис РСМ'
        if message_from_telegram.text == '/start'
          message = BotTelegram::Scenario::Step.find_by name: :start
          message_to_user bot, message.text, message_from_telegram

          sleep 3

          message = BotTelegram::Scenario::Step.find_by name: :do_you_have_project
          message_to_user bot, message, message_from_telegram
          BotTelegram::Scenario::ProgressRecord.create!(
            bot_telegram_user_id: user_from(message_from_telegram).id,
            bot_telegram_scenario_step_id: message.id
          )
        else
          user = user_from message_from_telegram
          current_step = user.steps.where(bot_id: bot_record.id).order(:created_at).last
          next_step = BotTelegram::Scenario::Step.find_by name: current_step.options[message_from_telegram.text]
          message_to_user bot, next_step, message_from_telegram
          BotTelegram::Scenario::ProgressRecord.create!(
            bot_telegram_user_id: user_from(message_from_telegram).id,
            bot_telegram_scenario_step_id: next_step.id
          )
        end
      end
    end
  end
end

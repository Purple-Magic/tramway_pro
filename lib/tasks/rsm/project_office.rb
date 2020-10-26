module RSM
  module ProjectOffice
    class << self
      include BotTelegram::MessagesManager
      include BotTelegram::Info

      def scenario(message_from_telegram, bot)
        if message_from_telegram.text == '/start'
          message = BotTelegram::Scenario::Step.find_by name: :start
          message_to_user bot, message.text, message_from_telegram

          sleep 3

          message = BotTelegram::Scenario::Step.find_by name: :do_you_have_project
          message_to_user bot, message, message_from_telegram
          BotTelegram::Scenario::ProgressRecord.create!(
            bot_telegram_user_id: user_from(message_from_telegram),
            bot_telegram_scenario_step_id: message
          )
        else
        end
      end
    end
  end
end

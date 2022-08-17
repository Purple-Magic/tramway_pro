module BotRunHelper
  def bot_run(scenario, bot_record:, message:, chat:, message_object:)
    scenario_class = "BotTelegram::#{scenario.to_s.camelize}Bot::Scenario".constantize

    Telegram::Bot::Client.run(bot_record.token) do |bot|
      scenario_class.new(
        message: message,
        bot: bot,
        bot_record: bot_record,
        chat: chat,
        message_object: message_object,
        user: message_object.user
      ).run
    end
  end
end

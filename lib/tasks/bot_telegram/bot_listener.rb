# frozen_string_literal: true

require 'telegram/bot'
require_relative 'scenario'
require_relative 'leopold'
require_relative 'leopold/scenario'

class BotTelegram::BotListener
  class << self
    include BotTelegram::Info
    include BotTelegram::MessagesManager

    def perform
      bot_record = Bot.find_by name: ENV['RUNNING_BOT_NAME']
      Telegram::Bot::Client.run(bot_record.token) do |bot|
        bot.listen do |message|
          user = user_from message
          chat = chat_from message
          log_message message, user, chat, bot_record
          if bot_record.custom
            scenario_class = "BotTelegram::#{bot_record.scenario.camelize.capitalize}::Scenario".constantize
            scenario = scenario_class.new message, bot, bot_record, chat
            scenario.run
          else
            BotTelegram::Scenario.run message, bot, bot_record
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => e
        Rails.env.development? ? puts(e) : Raven.capture_exception(e)
      end
    end
  end
end

BotTelegram::BotListener.perform

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
      bot_record = Bot.find ENV['RUNNING_BOT_ID']
      Telegram::Bot::Client.run(bot_record.token) do |bot|
        bot.listen do |message|
          if can_be_processed? message
            user = user_from message
            chat = chat_from message
            log_message message, user, chat, bot_record
            if bot_record.custom
              custom_bot_action bot_record: bot_record, bot: bot, chat: chat, message: message
            else
              BotTelegram::Scenario.run message, bot, bot_record
            end
          else
            error = "Empty message in bot #{bot_record.id}"
            Rails.env.development? ? puts(error) : Raven.capture_exception(error)
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => e
        Rails.env.development? ? puts(e) : Raven.capture_exception(e)
      end
    end

    def custom_bot_action(bot_record:, bot:, chat:, message:)
      scenario_class = "BotTelegram::#{bot_record.scenario.camelize.capitalize}::Scenario".constantize
      scenario = scenario_class.new message, bot, bot_record, chat
      scenario.run
    end

    def can_be_processed?(message)
      message.present? && (message.try(:text) || message.try(:sticker))
    end
  end
end

BotTelegram::BotListener.perform

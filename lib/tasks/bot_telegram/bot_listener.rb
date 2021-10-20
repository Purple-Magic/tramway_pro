# frozen_string_literal: true

require 'telegram/bot'
require_relative 'scenario'
require_relative 'leopold'
require_relative 'leopold/scenario'

class BotTelegram::BotListener
  class << self
    include BotTelegram::Info
    include BotTelegram::MessagesManager

    def perform(id)
      bot_record = Bot.find id
      Telegram::Bot::Client.run(bot_record.token) do |bot|
        bot.listen do |message|
          if can_be_processed? message
            process message, bot_record, bot
          else
            error = "Empty message in bot #{bot_record.name}"
            Rails.env.development? ? puts(error) : Airbrake.notify(error)
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => error
        Rails.env.development? ? puts(error) : Airbrake.notify(error)
      end
    end

    def custom_bot_action(**options)
      scenario_class = "BotTelegram::#{options[:bot_record].scenario.camelize.capitalize}::Scenario".constantize
      scenario = scenario_class.new(
        options[:message],
        options[:bot],
        options[:bot_record],
        options[:chat],
        options[:message_object]
      )
      scenario.run
    end

    def can_be_processed?(message)
      message.present? && (message.try(:text) || message.try(:sticker) || message.try(:data))
    end

    def process(message, bot_record, bot)
      user = user_from message.from
      chat = chat_from message.chat
      message_object = log_message message, user, chat, bot_record
      if bot_record.custom
        custom_bot_action bot_record: bot_record, bot: bot, chat: chat, message: message, message_object: message_object
      else
        BotTelegram::Scenario.run message, bot, bot_record
      end
    end
  end
end

# frozen_string_literal: true

require 'telegram/bot'
require_relative 'scenario'
require_relative 'leopold'
require_relative 'leopold/scenario'
require_relative 'benchkiller_bot/scenario'

class BotTelegram::BotListener
  class << self
    include BotTelegram::Info
    include BotTelegram::MessagesManager
    include BotTelegram::CallbacksManager

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

    def process_message(message, bot_record, bot)
      if message.from.present?
        process_message_from_user message, bot_record, bot
      else
        process_message_from_channel message, bot_record, bot
      end
    end

    def process_message_from_user(message, bot_record, bot)
      user = user_from message.from
      chat = chat_from message.chat, bot_record
      message_object = log_message message, user, chat, bot_record
      if bot_record.custom
        custom_bot_action bot_record: bot_record, bot: bot, chat: chat, message: message,
          message_object: message_object, user: user
      else
        BotTelegram::Scenario.run message, bot, bot_record
      end
    end

    def process_message_from_channel(message, bot_record, bot)
      channel = channel_from message.chat, bot_record
      if bot_record.custom
        custom_bot_action bot_record: bot_record, bot: bot, message: message, user: channel
      else
        BotTelegram::Scenario.run message, bot, bot_record
      end
    end

    def custom_bot_action(**options)
      scenario_class = "BotTelegram::#{options[:bot_record].scenario.camelize}::Scenario".constantize
      scenario = scenario_class.new(**options.slice(:message, :bot, :bot_record, :chat, :message_object, :user))
      scenario.run
    end

    def can_be_processed?(message)
      message.present? && (message.try(:text) || message.try(:sticker) || message.try(:data))
    end

    def process(object, bot_record, bot)
      if object.is_a? Telegram::Bot::Types::CallbackQuery
        process_callback object, bot_record, bot
      else
        process_message object, bot_record, bot
      end
    end

    def process_callback(message, bot_record, bot)
      user = user_from message.from
      chat = chat_from message.message.chat, bot_record
      callback_object = log_callback message, user, chat, bot_record
      if bot_record.custom
        custom_bot_action bot_record: bot_record, bot: bot, chat: chat, message: message,
          callback_object: callback_object, user: user
      else
        BotTelegram::Scenario.run message, bot, bot_record
      end
    end
  end
end

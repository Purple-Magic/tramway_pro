# frozen_string_literal: true

require_relative 'it_way_pro'
require_relative 'it_way_pro/words_check'
require_relative 'commands'
require_relative 'command'

class BotTelegram::Leopold::Scenario
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::Info
  include ::BotTelegram::Leopold::ItWayPro

  BOT_ID = 9
  PROJECT_CHAT_QUEST_ID = '-498758668'
  IT_WAY_PODCAST_ID = '-456783051'

  attr_reader :bot, :bot_record, :chat, :message_from_telegram

  def initialize(message_from_telegram, bot, bot_record, chat)
    @bot = bot
    @message_from_telegram = message_from_telegram
    @bot_record = bot_record
    @chat = chat
  end

  def run
    if chat_to_answer? chat
      text = message_from_telegram.text
      command = BotTelegram::Leopold::Command.new text
      if command.valid?
        command.run
      else
        it_way_process text
      end
    else
      chat_id = chat.telegram_chat_id.to_s
      message_to_chat bot, chat, bot_record.options['not_my_group'] unless chat_exceptions.values.include? chat_id
    end
  end

  def chat_exceptions
    {
      project_chat_quest_id: PROJECT_CHAT_QUEST_ID,
      it_way_podcast_id: IT_WAY_PODCAST_ID
    }
  end

  def chat_to_answer?(chat)
    chat_id = chat.telegram_chat_id.to_s
    (chat.private? || chat_id == ::BotTelegram::Leopold::ItWayPro::CHAT_ID) && !chat_exceptions.values.include?(chat_id)
  end
end

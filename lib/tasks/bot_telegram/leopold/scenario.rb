# frozen_string_literal: true

require_relative 'it_way_pro'
require_relative 'it_way_pro/words_check'
require_relative 'commands'
require_relative 'command'
require_relative '../custom/scenario'

class BotTelegram::Leopold::Scenario < ::BotTelegram::Custom::Scenario
  include ::BotTelegram::Leopold::ItWayPro
  include ::BotTelegram::Leopold::ChatsConcern

  BOT_ID = 9

  def run
    chat_decorator = BotTelegram::Leopold::ChatDecorator.new chat
    text = message_from_telegram.text
    if chat_decorator.to_answer?
      command = BotTelegram::Leopold::Command.new text, bot_record.slug, bot
      if command.valid?
        command.run
      else
        it_way_process text
      end
    else
    #  chat_id = chat.telegram_chat_id.to_s
    #  message_to_chat bot, chat, bot_record.options['not_my_group'] unless exceptions.values.include? chat_id
    end
  end
end

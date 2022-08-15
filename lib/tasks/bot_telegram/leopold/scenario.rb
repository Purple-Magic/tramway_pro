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

    if chat.private?
      message_to_chat bot, chat, bot_record.options['i_do_not_have_actions_in_private_chats']
    elsif chat_decorator.to_answer?
      if message.user.username == 'kalashnikovisme'
        message_to_chat bot, chat, 'Доброе утро, сэр!', reply_markup: []
      end
    end
  end
end

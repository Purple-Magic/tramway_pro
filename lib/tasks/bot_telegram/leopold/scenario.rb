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

    return unless chat_decorator.to_answer?

    chat_id = chat.telegram_chat_id.to_s
    unless exceptions.values.include? chat_id
      message_to_chat bot, chat,
        bot_record.options['i_do_not_have_actions_in_private_chats']
    end
  end
end

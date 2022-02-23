# frozen_string_literal: true

module BotTelegram::BenchkillerBot::Concern
  def i18n_scope(*keys, **attributes)
    I18n.t(keys.join('.'), scope: 'benchkiller.bot', **attributes)
  end

  def show(menu:, answer:)
    keyboard = ::BotTelegram::BenchkillerBot::MENUS[menu].map do |button_row|
      button_row.map do |button|
        ::BotTelegram::BenchkillerBot::BUTTONS[button]
      end
    end

    message = ::BotTelegram::Custom::Message.new text: answer, reply_markup: { keyboard: keyboard }

    user.set_finished_state_for bot: bot_record
    message_to_user bot.api, message, chat.telegram_chat_id
  end
end

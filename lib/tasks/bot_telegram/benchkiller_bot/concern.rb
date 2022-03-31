# frozen_string_literal: true

module BotTelegram::BenchkillerBot::Concern
  def i18n_scope(*keys, **attributes)
    I18n.t(keys.join('.'), scope: 'benchkiller.bot', **attributes)
  end

  def show(menu:, answer: nil)
    keyboard = ::BotTelegram::BenchkillerBot::MENUS[menu].map do |button_row|
      if button_row.is_a? Array
        button_row.map do |button|
          ::BotTelegram::BenchkillerBot::BUTTONS[button]
        end
      else
        ::BotTelegram::BenchkillerBot::BUTTONS[button_row]
      end
    end

    message = if answer.present?
                ::BotTelegram::Custom::Message.new text: answer, reply_markup: { keyboard: keyboard }
              else
                ::BotTelegram::Custom::Message.new reply_markup: { keyboard: keyboard }
              end

    user.set_finished_state_for bot: bot_record
    message_to_user bot.api, message, chat.telegram_chat_id
  end
end

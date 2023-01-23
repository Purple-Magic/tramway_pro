# frozen_string_literal: true

module BotTelegram::BenchkillerBot::Concern
  def i18n_scope(*keys, **attributes)
    key = keys.join('.')
    scope = 'benchkiller.bot'

    I18n.t(key, scope: scope, **attributes)
  end

  def show(answer:, menu: false, continue_action: false, options: false)
    raise "There no menu or options to show with answer #{answer}" if !menu.present? && !options.present?

    keyboard = (options || ::BotTelegram::BenchkillerBot::MENUS[menu]).map do |button_row|
      if button_row.is_a? Array
        button_row.map do |button|
          ::BotTelegram::BenchkillerBot::BUTTONS[button]
        end
      else
        ::BotTelegram::BenchkillerBot::BUTTONS[button_row]
      end
    end

    message = ::BotTelegram::Custom::Message.new text: answer, reply_markup: { keyboard: keyboard }

    message_to_user bot.api, message, chat.telegram_chat_id
  end
end

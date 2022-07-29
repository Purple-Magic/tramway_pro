# frozen_string_literal: true

module BotTelegram::FindMedsBot::Concern
  def i18n_scope(*keys, **attributes)
    key = keys.join('.')
    scope = 'find_meds.bot'

    I18n.t(key, scope: scope, **attributes)
  end

  def show(menu: false, answer:, continue_action: false, options: false)
    raise "There is no menu or options to show with answer #{answer}" if !menu.present? && !options.present?

    keyboard = (options || ::BotTelegram::FindMedsBot::MENUS[menu]).map do |button_row|
      if button_row.is_a? Array
        button_row.map do |button|
          button_text button
        end
      else
        button_text button_row
      end
    end

    message = ::BotTelegram::Custom::Message.new text: answer, reply_markup: { keyboard: keyboard }

    message_to_user bot.api, message, chat.telegram_chat_id
  end

  private

  def button_text(button)
    ::BotTelegram::FindMedsBot::BUTTONS[button] || button
  end
end

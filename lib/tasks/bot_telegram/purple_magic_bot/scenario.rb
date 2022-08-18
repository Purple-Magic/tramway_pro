# frozen_string_literal: true

require_relative '../custom/scenario'

class BotTelegram::PurpleMagicBot::Scenario < ::BotTelegram::Custom::Scenario
  BOT_ID = 7

  MENUS = {
    start_menu: [
      %i[rosterize service_guru slurm],
      %i[tramway_admin chat_quests]
    ]
  }.freeze

  BUTTONS = {
    rosterize: '🛫 Rosterize',
    service_guru: '🍵 Service Guru',
    slurm: '🖱 Slurm',
    tramway_admin: '🚟 tramway-admin',
    chat_quests: '🧛 Чат-квесты'
  }.freeze

  def run
    if start_action?
      start
    elsif button_action?
      public_send BUTTONS.invert[message_from_telegram.text], nil
    end
  end

  BUTTONS.each do |(method_name, _)|
    define_method method_name do |_argument|
      answer = i18n_scope method_name, :text
      show menu: :start_menu, answer: answer
    end
  end

  private

  def start(_text: nil)
    answer = i18n_scope(:start, :text)
    show menu: :start_menu, answer: answer
  end

  def start_action?
    message_from_telegram.try(:text) && message_from_telegram.text == '/start'
  end

  def button_action?
    message_from_telegram.try(:text) && message_from_telegram.text.in?(BUTTONS.values)
  end

  def i18n_scope(*keys, **attributes)
    I18n.t(keys.join('.'), scope: 'purple_magic.bot', **attributes)
  end

  def show(menu:, answer:)
    keyboard = MENUS[menu].map do |button_row|
      button_row.map do |button|
        BUTTONS[button]
      end
    end

    message = ::BotTelegram::Custom::Message.new text: answer, reply_markup: { keyboard: keyboard }

    user.set_finished_state_for bot: bot_record
    message_to_user bot.api, message, chat.telegram_chat_id
  end
end

# frozen_string_literal: true

module BotTelegram::StatsNotifications
  include ::BotTelegram::Leopold::Notify
  include ::BotTelegram::Info

  def notify_about_finishing_scenario(message_from_telegram, bot_record)
    user = user_from message_from_telegram.from
    message = "Пользователь #{user.username} прошёл квест #{bot_record.name}"
    chat_id = ::BotTelegram::Leopold::ChatDecorator::PROJECT_CHAT_QUEST_ID
    send_notification_to_chat chat_id, message
  end
end

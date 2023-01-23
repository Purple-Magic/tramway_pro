# frozen_string_literal: true

module BotTelegram::StatsNotifications
  include ::BotTelegram::Leopold::Notify
  include ::BotTelegram::Info

  def notify_about_finishing_scenario(message_from_telegram, bot_record)
    user = user_from message_from_telegram.from
    message = if user.username.present?
                "Пользователь @#{user.username} прошёл квест #{bot_record.name}"
              else
                "Очередной пользователь прошёл квест #{bot_record.name}. У данного пользователя нет никнейма в Telegram, обратитесь к программистам, чтобы они связались с пользователем через бота. ID пользователя #{user.id}"
              end
    chat_id = ::BotTelegram::Leopold::ChatDecorator::PROJECT_CHAT_QUEST_ID
    send_notification_to_chat chat_id, message
  end
end

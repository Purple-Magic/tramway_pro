module BotTelegram::StatsNotifications
  include ::BotTelegram::Leopold::Notify
  include ::BotTelegram::Info

  def notify_about_finishing_scenario(message_from_telegram, bot_record)
    user = user_from message_from_telegram.from
    message = "Пользователь #{user.username} прошёл квест #{bot_record.name}" 
    send_notification_to :kalashnikovisme, message
  end
end

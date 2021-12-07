# frozen_string_literal: true

class BenchkillerSendApprovementMessageWorker < ApplicationWorker
  sidekiq_options queue: :benchkiller

  include ::BotTelegram::BenchkillerBot::Notify

  def perform(user_id)
    text = <<-TEXT
Поздравляем!
Ваша компания была подтверждена!
Теперь ваши сообщения будут автоматически попадать в наши каналы размещения
TEXT
    send_notification_to_user Benchkiller::User.find(user_id).telegram_user.username, text
  end
end

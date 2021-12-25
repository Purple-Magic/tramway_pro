# frozen_string_literal: true

class Benchkiller::SendRejectionMessageWorker < ApplicationWorker
  sidekiq_options queue: :benchkiller

  include ::BotTelegram::BenchkillerBot::Notify

  def perform(user_id)
    text = <<~TEXT
            Ваша карточка компании не подтверждена модератором.
      #{'      '}
            Пожалуйста проверьте полноту и правильность заполнения информации.
      #{'      '}
            Если у вас есть вопросы по заполнению карточки вы можете связаться с @Egurt73
    TEXT
    send_notification_to_user Benchkiller::User.find(user_id).telegram_user.username, text
  end
end

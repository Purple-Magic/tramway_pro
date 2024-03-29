# frozen_string_literal: true

require 'bot_telegram/benchkiller_bot'
require 'bot_telegram/benchkiller_bot/notify'

class BenchkillerSendPlannedNotifications < ActiveJob::Base
  queue_as :benchkiller
  include ::BotTelegram::BenchkillerBot::Notify

  def perform(*_args)
    time = DateTime.now.in_time_zone('Moscow').strftime('%H:%M')
    ::Benchkiller::Notification.find_each do |notification|
      if time == notification.send_at
        send_notification_to_chat(
          ::BotTelegram::BenchkillerBot::MAIN_CHAT_ID,
          notification.text
        )
      end
    end
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end
end

# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/benchkiller_bot'
require_relative '../../lib/tasks/bot_telegram/benchkiller_bot/notify'

class BenchkillerSendPlannedNotifications < ActiveJob::Base
  queue_as :benchkiller
  include ::BotTelegram::BenchkillerBot::Notify

  def perform(*_args)
    time = DateTime.now.strftime('%H:%M')
    ::Benchkiller::Notification.active.find_each do |notification|
      if time == notification.send_at
        send_notification_to_chat(
          ::BotTelegram::BenchkillerBot::MAIN_CHAT_ID,
          notification.text
        )
      end
    end
  end
end

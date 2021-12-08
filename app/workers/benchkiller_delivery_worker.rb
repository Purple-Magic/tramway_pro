# frozen_string_literal: true

class BenchkillerDeliveryWorker < ApplicationWorker
  sidekiq_options queue: :benchkiller

  include ::BotTelegram::BenchkillerBot::Notify

  def perform(ids, text)
    ids.each do |receiver_id|
      user = ::BotTelegram::User.find(receiver_id)
      send_notification_to_user user.username, text
    end
  end
end

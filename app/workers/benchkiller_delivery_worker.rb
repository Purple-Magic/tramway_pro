class BenchkillerDeliveryWorker < ApplicationWorker
  sidekiq_options queue: :benchkiller

  include ::BotTelegram::BenchkillerBot::Notify

  def perform(ids, text)
    receivers_ids = ids.map do |offer_id|
      ::Benchkiller::Offer.find(offer_id).message.user.id
    end.uniq
    receivers_ids.each do |receiver_id|
      user = ::BotTelegram::User.find(receiver_id)
      send_notification_to_user user.username, text
    end
  end
end

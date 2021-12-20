# frozen_string_literal: true

class Benchkiller::SendOfferToPublicChannelWorker < ApplicationWorker
  sidekiq_options queue: :benchkiller

  include ::BotTelegram::BenchkillerBot::Notify

  def perform(offer_id, channel)
    text = ::Benchkiller::Offer.find(offer_id).message.text
    send_notification_to_channel channel, text
  end
end

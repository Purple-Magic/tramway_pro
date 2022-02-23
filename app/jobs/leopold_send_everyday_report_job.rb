# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/leopold/tracker'

class LeopoldSendEverydayReportJob < ActiveJob::Base
  queue_as :default

  include ::BotTelegram::Leopold::Tracker

  def perform(*_args)
    Product.find_each do |product|
      send_everyday_report product if product.chat_id.present?
    end
  end
end

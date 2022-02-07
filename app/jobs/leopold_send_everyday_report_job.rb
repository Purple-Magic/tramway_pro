require_relative '../../lib/tasks/bot_telegram/leopold/tracker'

class LeopoldSendEverydayReportJob < ActiveJob::Base
  queue_as :default

  include ::BotTelegram::Leopold::Tracker

  def perform(*_args)
    Product.where.not(chat_id: nil).find_each do |product|
      send_everyday_report product
    end
  end
end

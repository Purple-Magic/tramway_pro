# frozen_string_literal: true

module BotTelegram::Leopold::Tracker
  include ::BotTelegram::Leopold::Notify

  def send_everyday_report(product)
    decorated_product = ProductDecorator.decorate product
    send_notification_to_chat product.chat_id, decorated_product.everyday_report(DateTime.yesterday)
  end
end

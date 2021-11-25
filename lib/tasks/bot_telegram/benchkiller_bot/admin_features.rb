require_relative 'notify'

module BotTelegram::BenchkillerBot::AdminFeatures
  include ::BotTelegram::BenchkillerBot::Notify

  def send_approve_message_to_admin_chat(offer)
    text = ::Benchkiller::Offers::AdminChatDecorator.decorate(offer).admin_message
    keyboard = [
      [
        ['Подтвердить', { data: { command: :approve_offer, offer_id: offer.id } }],
        ['Отклонить', { data: { command: :decline_offer, offer_id: offer.id } }]
      ]
    ]
    message = ::BotTelegram::Custom::Message.new text: text, inline_keyboard: keyboard
    send_notification_to_chat ::BotTelegram::BenchkillerBot::ADMIN_CHAT_ID, message
  end

  private
end

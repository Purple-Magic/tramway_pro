require_relative 'notify'

module BotTelegram::BenchkillerBot::AdminFeatures
  include ::BotTelegram::BenchkillerBot::Notify

  def send_approve_message_to_admin_chat(offer)
    text = ::Benchkiller::Offers::AdminChatDecorator.decorate(offer).admin_message
    keyboard = [
      [
        ['Подтвердить', { data: { command: :approve_offer, argument: offer.id } }],
        ['Отклонить', { data: { command: :decline_offer, argument: offer.id } }]
      ]
    ]
    message = ::BotTelegram::Custom::Message.new text: text, inline_keyboard: keyboard
    send_notification_to_chat ::BotTelegram::BenchkillerBot::ADMIN_CHAT_ID, message
  end

  def approve_offer(argument)
    offer = ::Benchkiller::Offer.find argument 
    offer.approve
  end

  def decline_offer(argument)
    offer = ::Benchkiller::Offer.find argument 
    offer.decline
  end
end

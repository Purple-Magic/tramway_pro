# frozen_string_literal: true

class Benchkiller::Offers::AdminChatDecorator < ::Benchkiller::OfferDecorator
  def admin_message
    text = "*From:* @#{message.user.username}"
    text += "\n\n"
    text += '*Message:*'
    text += "\n"
    text += message.text
    text += "\n\n*Hashtags: *"
    text += object.tags.map(&:title).join(' ')
  end
end

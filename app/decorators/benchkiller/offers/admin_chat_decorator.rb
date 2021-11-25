class Benchkiller::Offers::AdminChatDecorator < ::Benchkiller::OfferDecorator
  def admin_message
    text = "*From:* @#{message.user.username}"
    text += "\n\n"
    text += "*Message:*"
    text += "\n"
    text += message.text
    text += "*Hashtags: *"
    text += object.tags.map do |tag|
      tag.title
    end.join(' ')
  end
end

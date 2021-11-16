bot = Bot.find 13

bot.messages.each_with_index do |message, index|
  if message.chat.telegram_chat_id == '-1001076312571'
    unless Benchkiller::Offer.find_by(message_id: message.id).present?
      Benchkiller::Offer.create! message_id: message.id, project_id: 7
    end
  end
  print "#{index} of #{bot.messages.count}\r"
end

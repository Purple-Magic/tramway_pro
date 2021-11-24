ids = Benchkiller::Offer.active.map(&:message_id)

chat = BotTelegram::Chat.find_by telegram_chat_id: '-1001076312571'
messages = chat.messages.where.not(id: ids).includes(:chat)
messages.each_with_index do |message, index|
  Benchkiller::Offer.create! message_id: message.id, project_id: 7
  print "#{index} of #{messages.count}\r"
end


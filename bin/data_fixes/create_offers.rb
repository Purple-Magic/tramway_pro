bot = Bot.find 13

bot.messages.each_with_index do |message, index|
  if message.chat.telegram_chat_id == '-1001076312571'
    Benchkiller::Offer.create! message_id: message.id, project_id: 7
  end
  print "#{index} of #{bot.messages.count}\r"
end

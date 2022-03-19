count = BotTelegram::Message.count

BotTelegram::Message.find_each.with_index do |message, index|
  message.update! telegram_message_id: message.options&.dig('message_id')
  print "#{index} of #{count}\r"
end

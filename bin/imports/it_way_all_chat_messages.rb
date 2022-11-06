json = JSON.parse(File.readlines('it-way.json').join("\n"))

chat = BotTelegram::Chat.find 1694
messages = chat.messages
count = json['messages'].count 
json['messages'].each_with_index do |msg, index|
  # next if index < 21161
  puts "#{index} of #{count}"
  message = messages.map do |message|
    message if message.options&.dig('id').to_s == msg['id'].to_s || message.telegram_message_id.to_s == msg['id'].to_s
  end.compact.first
  unless message.present?
    from_type = msg['from_id'].present? ? 'from' : 'actor'
    from = msg["#{from_type}_id"]

    next if from.include? 'channel'

    user = BotTelegram::User.find_by telegram_id: from.sub('user', '')

    unless user.present?
      user = BotTelegram::User.create! telegram_id: from.sub('user', ''),
        first_name: msg[from_type]&.split(' ')&.first, 
        last_name: msg[from_type]&.split(' ')&.last
    end
    text = if msg['text'].is_a? String
             text
           else
             msg['text'].select { |t| t.is_a? String }.join
           end
    message = BotTelegram::Message.create! chat_id: chat.id,
      user_id: user.id,
      text: text,
      message_type: :regular,
      telegram_message_id: msg['id'],
      bot_id: 9,
      project_id: 7
    message.update_column :created_at, msg['date'].to_datetime
  end
end

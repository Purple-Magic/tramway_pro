require 'csv'

table = CSV.read 'messages.csv'
users = CSV.read('persons.csv')
table.each_with_index do |row, index|
  next if index == 0
  next if row[6].nil?
  client_id = row[6].to_s
  client = users.select do |user_row|
    user_row[0].to_s == client_id
  end.first
  user_id = BotTelegram::User.find_by(telegram_id: client[1]).id
  message_info = JSON.parse(row[2]).with_indifferent_access
  next if message_info[:message].nil?
  BOT_ID = 13
  chat_id = BotTelegram::Chat.find_or_create_by!(
    telegram_chat_id: message_info[:message][:chat][:id],
    title: message_info[:message][:chat][:title],
    chat_type: row[1],
    project_id: 7,
    bot_id: BOT_ID
  ).id
  message = BotTelegram::Message.create! chat_id: chat_id, user_id: user_id, text: row[10],
    options: message_info, project_id: 7, bot_id: BOT_ID
  message.update_column :created_at, DateTime.new(row[3])
  print "#{index} of #{table.count}\r"
end

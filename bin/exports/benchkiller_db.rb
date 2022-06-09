require_relative './whole_exports'

code = []

puts 'Exporting bot'
bot = Bot.find 13
attributes = build_attributes bot, has_name: false, ignore_keys: [ 'project_id' ]
code << "attributes = #{attributes.symbolize_keys}"
code << "bot = Tramway::Bots::Bot.create! **attributes"

chat = BotTelegram::Chat.find_by telegram_chat_id: '-1001076312571'

puts 'Exporting companies'
count = Benchkiller::Company.count
Benchkiller::Company.find_each.with_index do |company, index|
  attributes = build_attributes company, has_name: false, ignore_keys: [ 'project_id' ]
  code << "attributes = #{attributes.symbolize_keys}"
  code << "company = Company.create! **attributes"
  code << "puts '#{index} of #{count}'"
end

puts 'Exporting users'
count = chat.users.uniq.count
code << "puts 'Import users #{count}'"
chat.users.uniq.each_with_index do |user, index|
  next if user.id == 6163
  attributes = build_attributes user, ignore_keys: [ 'project_id' ], has_name: false
  code << "attributes = #{attributes.symbolize_keys}"
  code << "user = Tramway::Bots::Telegram::User.create! **attributes"
  benchkiller_user = Benchkiller::User.find_by bot_telegram_user_id: user.id
  if benchkiller_user.present?
    attributes = build_attributes benchkiller_user, ignore_keys: [ 'project_id', 'bot_telegram_user_id' ], has_name: false
    code << "attributes = #{attributes.symbolize_keys}"
    code << "u = User.new **attributes.merge(telegram_user_id: user.id)"
    code << "u.password = SecureRandom.hex(16)"
    code << "u.save!"
    benchkiller_user.companies.each do |company|
      code << "company = Company.find_by title: '#{company.title}'"
      code << "u.companies << company"
      code << "u.save!"
    end
  end
  code << "puts 'Users #{index}'"
  print "#{index} of #{count}\r"
end

puts 'Exporting messages & offers'
count = chat.messages.count
code << "puts 'Import messages #{count}'"
attributes = build_attributes chat, has_name: false, ignore_keys: [ 'project_id', 'telegram_id' ]
code << "attributes = #{attributes.symbolize_keys}"
code << "Tramway::Bots::Telegram::Chat.create! **attributes.merge(bot_id: bot.id)"
chat.messages.each_with_index do |message, index|
  next unless message.user.present?

  attributes = build_attributes message, has_name: false, ignore_keys: [ 'project_id', 'user_id' ]
  code << "attributes = #{attributes.symbolize_keys}"
  code << "user = Tramway::Bots::Telegram::User.find_by telegram_id: #{message.user.telegram_id}"
  code << "message = Tramway::Bots::Telegram::Message.create! **attributes.merge(user_id: user.id)"
  Benchkiller::Offer.where(message_id: message.id).each_with_index do |offer|
    attributes = build_attributes offer, has_name: false, ignore_keys: [ 'project_id', 'message_id' ]
    code << "attributes = #{attributes.symbolize_keys}"
    code << "offer = Offer.create! **attributes.merge(message_id: message.id)"
    code << "offer.parse!"
  end
  code << "puts 'Messages #{index}'" if index % 1000 == 0
  print "#{index} of #{count}\r"
end


filename = "export_benchkiller_db.rb"
File.delete filename if File.exists? filename
File.open(filename, 'w') { |file| file.write code.join("\n") }

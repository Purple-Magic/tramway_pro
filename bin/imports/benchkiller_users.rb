require 'csv'

table = CSV.read('persons.csv')
table.each_with_index do |row, index|
  unless BotTelegram::User.find_by telegram_id: row[1]
    telegram_user = BotTelegram::User.find_or_create_by! telegram_id: row[1],
      username: row[2],
      first_name: row[3],
      last_name: row[12]
  end

  if telegram_user.present? && Benchkiller::User.active.find_by(bot_telegram_user_id: telegram_user.id).nil?
    Benchkiller::User.create! bot_telegram_user_id: telegram_user.id,
      project_id: 7,
      password: SecureRandom.hex(16)
  end
  print "#{index} of #{table.count}\r"
end

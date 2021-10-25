require 'csv'

table = CSV.read('persons.csv')
table.each_with_index do |row, index|
  telegram_user = BotTelegram::User.find_or_create_by! telegram_id: row[1],
    username: row[2],
    first_name: row[3],
    last_name: row[12]

  Benchkiller::User.create! bot_telegram_user_id: telegram_user.id,
    project_id: 7
  print "#{index} of #{table.count}\r"
end

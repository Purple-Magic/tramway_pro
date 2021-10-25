require 'csv'

table = CSV.read('companies.csv')
users = CSV.read('persons.csv')
table.each_with_index do |row, index|
  next if index == 0
  company = Benchkiller::Company.find(4 + index)
  client_id = row[12].to_s
  client = users.select do |user_row|
    user_row[0].to_s == client_id
  end.first
  next if client.nil?
  benchkiller_user = Benchkiller::User.find_by bot_telegram_user_id: BotTelegram::User.find_by(telegram_id: client[1]).id
  Benchkiller::CompaniesUser.create! user_id: benchkiller_user.id,
    company_id: company.id
  print "#{index} of #{table.count}\r"
end

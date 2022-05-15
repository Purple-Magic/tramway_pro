require_relative './whole_exports'

code = []

puts 'Exporting telegram users'
count = BotTelegram::User.count
# code << "puts 'Import users #{count}'"
# BotTelegram::User.find_each.with_index do |user, index|
#   next if user.id == 6163
#   attributes = build_attributes user, ignore_keys: [ 'project_id' ], has_name: false
#   code << "attributes = #{attributes.symbolize_keys}"
#   code << "Tramway::Bots::Telegram::User.create! **attributes"
#   code << "puts 'Telegram Users #{index}'" if index % 1000 == 0
#   print "#{index} of #{count}\r"
# end

# puts 'Exporting users'
# count = Benchkiller::User.count
# code << "puts 'Import users #{count}'"
# Benchkiller::User.find_each.with_index do |user, index|
#   attributes = build_attributes user, ignore_keys: [ 'project_id' ], has_name: false
#   code << "attributes = #{attributes.symbolize_keys}"
#   code << "u = User.new **attributes"
#   code << "u.save validate: false"
#   code << "puts 'Benchkiller Users #{index}'" if index % 1000 == 0
#   print "#{index} of #{count}\r"
# end

puts 'Exporting messages & offers'
count = BotTelegram::Message.count
code << "puts 'Import messages #{count}'"
BotTelegram::Message.find_each.with_index do |message, index|
  attributes = build_attributes message, has_name: false, ignore_keys: [ 'project_id' ]
  code << "attributes = #{attributes.symbolize_keys}"
  code << "Tramway::Bots::Telegram::Message.create! **attributes"
  Benchkiller::Offer.where(message_id: message.id).each_with_index do |offer, index|
    attributes = build_attributes offer, has_name: false, ignore_keys: [ 'project_id' ]
    code << "attributes = #{attributes.symbolize_keys}"
    code << "Offer.create! **attributes"
    code << "puts 'Offers #{index}'" if index % 1000 == 0
    print "#{index} of #{count}\r"
  end
  code << "puts 'Messages #{index}'" if index % 1000 == 0
  print "#{index} of #{count}\r"
end

filename = "export_benchkiller_db.rb"
File.delete filename if File.exists? filename
File.open(filename, 'w') { |file| file.write code.join("\n") }

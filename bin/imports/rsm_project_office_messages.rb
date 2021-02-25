require 'colorize'

messages = YAML.load_file("#{Rails.root}/bin/imports/rsm_project_office_texts.yml")
bot = Bot.find_by name: 'Проектный офис РСМ'
BotTelegram::Scenario::Step.where(bot_id: bot.id).delete_all
messages['messages'].each do |message|
  BotTelegram::Scenario::Step.create! bot_id: bot.id, **message
  puts "#{message['name']} imported".green
end

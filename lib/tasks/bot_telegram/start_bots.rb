require 'colorize'

Bot.active.find_each do |bot|
  command = "RUNNING_BOT_NAME=\"#{bot.name}\" /bin/bash -lic 'exec bundle exec rails runner lib/tasks/bot_telegram/bot_listener.rb &'"
  puts command.blue
  system command
  puts "#{bot.name} started".green
end

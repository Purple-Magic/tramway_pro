# frozen_string_literal: true

require 'colorize'

Bot.active.find_each do |bot|
  bot_listener_file = 'lib/tasks/bot_telegram/bot_listener.rb'
  command = "RUNNING_BOT_ID=\"#{bot.id}\" /bin/bash -lic 'exec bundle exec rails runner #{bot_listener_file} &'"
  puts command.blue
  system command
  puts "#{bot.name} started".green
end

# frozen_string_literal: true

require 'colorize'

Bot.active.find_each do |bot|
  bot_listener_file = 'lib/tasks/bot_telegram/bot_listener.rb'
  BotJob.perform_later bot.id
  puts "#{bot.name} started".green
end

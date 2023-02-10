# frozen_string_literal: true

require 'colorize'

Bot.find_each do |bot|
  BotWorker.perform_async bot.id, bot.name
  message = "#{bot.name} started"
  puts message.green
end

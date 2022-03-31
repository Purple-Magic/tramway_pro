# frozen_string_literal: true

require 'colorize'

Bot.find_each do |bot|
  BotWorker.perform_async bot.id, bot.name
  puts "#{bot.name} started".green
end

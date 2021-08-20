# frozen_string_literal: true

require 'colorize'

#Bot.active.find_each do |bot|
  bot = Bot.find 5
  BotJob.perform_later bot.id, bot.name
  puts "#{bot.name} started".green
#nd

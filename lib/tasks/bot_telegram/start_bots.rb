# frozen_string_literal: true

require 'colorize'

Bot.active.find_each do |bot|
  unless bot.id == 13
    BotJob.perform_later bot.id, bot.name
    puts "#{bot.name} started".green
  end
end

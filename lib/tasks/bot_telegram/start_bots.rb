# frozen_string_literal: true

require 'colorize'
require_relative './leopold/notify'

include BotTelegram::Leopold::Notify

Bot.find_each do |bot|
  BotWorker.perform_async bot.id, bot.name
  message = "#{bot.name} started"
  puts message.green

  send_notification_to_user :kalashnikovisme, message
end

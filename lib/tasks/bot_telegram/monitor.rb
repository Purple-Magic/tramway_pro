require_relative './leopold/notify'

include BotTelegram::Leopold::Notify

active_bots = Sidekiq::Workers.new.map do |worker|
  worker.third['payload']['args'].last
end

message = if active_bots.count == Bot.count
            "Все боты работают!"
          else
            "#{Bot.pluck(:name) - active_bots.join(' ')} лежат. Надо их срочно поднять!"
          end

send_notification_to_user :kalashnikovisme, message

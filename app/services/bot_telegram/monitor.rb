# include BotTelegram::Leopold::Notify

# active_bots = Sidekiq::Workers.new.map do |worker|
#   worker.third['payload']['args'].last
# end

# message = if active_bots.count >= Bot.count
#             "Все боты работают!"
#           else
#             "Боты лежат!\n#{(Bot.pluck(:name) - active_bots).join("\n")}"
#           end

# send_notification_to_user :kalashnikovisme, message

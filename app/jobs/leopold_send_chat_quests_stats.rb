# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/leopold/scenario'
require_relative '../../lib/tasks/bot_telegram/leopold/notify'
require_relative '../../lib/tasks/bot_telegram/leopold/chat_decorator'
require_relative '../../lib/tasks/bot_telegram/chat_quests/stats'

class LeopoldSendChatQuestsStats < ActiveJob::Base
  queue_as :default
  include ::BotTelegram::Leopold::Notify
  include ::BotTelegram::ChatQuests::Stats

  CHAT_QUESTS_BOTS_IDS = [2, 3, 4, 5, 6, 8, 10, 11, 12]

  def perform(*_args)
    bot = Bot.find ::BotTelegram::Leopold::Scenario::BOT_ID
    bots = Bot.where id: CHAT_QUESTS_BOTS_IDS
    bots.each do |bot|
      send_notification_to_chat(
        ::BotTelegram::Leopold::ChatDecorator::PROJECT_CHAT_QUEST_ID,
        stats_between_dates(bot, DateTime.now - 1.week, DateTime.now)
      )
    end
  end
end

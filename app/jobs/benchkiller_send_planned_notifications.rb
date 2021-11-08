# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/benchkiller_bot/notify'

class BenchkillerSendPlannedNotifications < ActiveJob::Base
  queue_as :default
  include ::BotTelegram::BenchkillerBot::Notify

  def perform(*_args)
    bots = Bot.where id: CHAT_QUESTS_BOTS_IDS
    bots.each do |bot|
      send_notification_to_chat(
        ::BotTelegram::Leopold::ChatDecorator::PROJECT_CHAT_QUEST_ID,
        stats_between_dates(bot, DateTime.now - 1.week, DateTime.now)
      )
    end
  end
end

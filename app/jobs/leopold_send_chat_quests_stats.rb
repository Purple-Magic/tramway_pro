# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/leopold/scenario'
require_relative '../../lib/tasks/bot_telegram/leopold/notify'
require_relative '../../lib/tasks/bot_telegram/leopold/chat_decorator'
require_relative '../../lib/tasks/bot_telegram/chat_quests/stats'

class LeopoldSendChatQuestsStats < ActiveJob::Base
  queue_as :default
  include ::BotTelegram::Leopold::Notify
  include ::BotTelegram::ChatQuests::Stats

  def perform(*_args)
    bot = Bot.find ::BotTelegram::Leopold::Scenario::BOT_ID
    #send_notification_to_chat ::BotTelegram::Leopold::ChatDecorator::PROJECT_CHAT_QUEST_ID,
      'Это сообщение: проверка. В ближайшие часы буду её слать каждые 10 минут, чтобы быть уверенным, что работаю стабильно. Чуть позже, Паша, это прекратит.'
    send_notification_to_user :kalashnikovisme,
      stats_between_dates(DateTime.now - 1.week, DateTime.now)
  end
end

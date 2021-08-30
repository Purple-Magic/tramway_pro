module BotTelegram::ChatQuests::Stats
  CHAT_QUESTS_BOTS_IDS = [2, 3, 4, 5, 6, 8, 10, 11, 12]

  def stats_between_dates(begin_date, end_date)
    bots = Bot.where id: CHAT_QUESTS_BOTS_IDS
    stat_message = "Статистика квесто в период с #{begin_date.strftime('%d.%m.%Y')} - #{end_date.strftime('%d.%m.%Y')}"
    bots.reduce('') do |stat_message, bot|
      # rubocop:disable Style/StringConcatenation
      stat_message + bot.name
      stat_message + "\n"
      stat_message + "Общее количество пользователей: #{bot.users.count}"
      stat_message + "\n"
      stat_message + "Новые пользователи за период: #{bot.new_users_between(begin_date, end_date).count}"
      stat_message + "\n"
      stat_message + "Уникальные пользователи за период: #{bot.uniq_users_between(begin_date, end_date).count}"
      stat_message + "\n"
      stat_message + "Общее количество сообщений: #{bot.messages.count}"
      # rubocop:enable Style/StringConcatenation
    end
  end
end

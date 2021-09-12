# frozen_string_literal: true

module BotTelegram::ChatQuests::Stats
  def stats_between_dates(bot, begin_date, end_date)
    <<-TXT
    🤖 #{bot.name}

    📅 Отчёт за период с #{begin_date.strftime('%d.%m.%Y')} по #{end_date.strftime('%d.%m.%Y')}

    🔶 Общее количество пользователей: #{bot.users.uniq.count}
    🔶 Новые пользователи за период: #{bot.new_users_between(begin_date, end_date).count}
    🔶 Уникальные пользователи за период: #{bot.uniq_users_between(begin_date, end_date).count}
    🔶 Общее количество сообщений: #{bot.messages.count}
    TXT
  end
end

# frozen_string_literal: true

module BenchkillerHelpers
  def benchkiller_i18n_scope(*keys, **attributes)
    I18n.t(keys.join('.'), scope: 'benchkiller.bot', **attributes)
  end

  def create_benchkiller_bot
    bot = Bot.with_deleted.find_by(id: 13)
    if bot.present?
      bot.restore
      bot 
    else
      bot = create :benchkiller_bot
      bot.update_column :id, 13
      bot
    end
  end
end

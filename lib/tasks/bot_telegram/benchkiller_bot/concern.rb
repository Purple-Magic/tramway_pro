# frozen_string_literal: true

module BotTelegram::BenchkillerBot::Concern
  def i18n_scope(*keys, **attributes)
    I18n.t(keys.join('.'), scope: 'benchkiller.bot', **attributes)
  end
end

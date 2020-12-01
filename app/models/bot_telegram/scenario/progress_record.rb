class BotTelegram::Scenario::ProgressRecord < ApplicationRecord
  belongs_to :step, class_name: 'BotTelegram::Scenario::Step', foreign_key: :bot_telegram_scenario_step_id
  belongs_to :user, class_name: 'BotTelegram::User', foreign_key: :bot_telegram_user_id

  scope :partner_scope, -> (_user_id) { all }
  scope :rsm_scope, -> (_user_id) { joins(step: :bot).where('bots.team = ?', :rsm) }
end

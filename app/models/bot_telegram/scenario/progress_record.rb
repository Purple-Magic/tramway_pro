# frozen_string_literal: true

class BotTelegram::Scenario::ProgressRecord < ApplicationRecord
  self.table_name = 'bot_telegram_scenario_progress_records'

  belongs_to :step, class_name: 'BotTelegram::Scenario::Step', foreign_key: :bot_telegram_scenario_step_id
  belongs_to :user, class_name: 'BotTelegram::User', foreign_key: :bot_telegram_user_id

  scope :partner_scope, ->(_user_id) { all }
  %i[rsm night purple_magic podcast].each do |team|
    scope "#{team}_scope".to_sym, ->(_user_id) { joins(step: :bot).where('bots.team = ?', team) }
  end
end

class BotTelegram::Scenario::ProgressRecord < ApplicationRecord
  belongs_to :step, class_name: 'BotTelegram::Scenario::Step', foreign_key: :bot_telegram_scenario_step_id
  belongs_to :user, class_name: 'BotTelegram::User', foreign_key: :bot_telegram_user_id
end

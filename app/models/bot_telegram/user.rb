# frozen_string_literal: true

class BotTelegram::User < ApplicationRecord
  self.table_name = :bot_telegram_users

  has_many :messages, class_name: 'BotTelegram::Message'
  has_many :progress_records, class_name: 'BotTelegram::Scenario::ProgressRecord', foreign_key: :bot_telegram_user_id
  has_many :steps, class_name: 'BotTelegram::Scenario::Step', through: :progress_records
  has_many :bots, class_name: 'Bot', through: :steps
  has_many :states, class_name: 'BotTelegram::Users::State'

  validates :telegram_id, uniqueness: true, if: -> { state == 'active' }
  validates :username, uniqueness: true, if: -> { state == 'active' }, allow_nil: true

  search_by :first_name, :username, :last_name

  scope :partner_scope, ->(_user_id) { all }
  %i[rsm night purple_magic].each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      step_ids = Bot.where(team: team).map(&:steps).flatten.map(&:id)
      records = BotTelegram::Scenario::ProgressRecord.where(bot_telegram_scenario_step_id: step_ids)
      BotTelegram::User.where id: records.map(&:bot_telegram_user_id)
    }
  end

  def current_state(bot)
    states.where(bot_id: bot.id).last&.current_state
  end

  def set_finished_state_for(bot:)
    states.create! bot_id: bot.id, current_state: :finished
  end

  def finished_state_for?(bot:)
    states.empty? || states.where(bot_id: bot.id).last&.current_state == 'finished'
  end
end

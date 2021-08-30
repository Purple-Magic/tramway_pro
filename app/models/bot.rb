# frozen_string_literal: true

class Bot < ApplicationRecord
  has_many :steps, -> { order(:name) }, class_name: 'BotTelegram::Scenario::Step'
  has_many :progress_records, through: :steps, class_name: 'BotTelegram::Scenario::ProgressRecord'
  has_many :attenders, through: :progress_records, class_name: 'BotTelegram::User', source: :user
  has_many :messages, class_name: 'BotTelegram::Message'
  has_many :users, through: :messages, class_name: 'BotTelegram::User'

  enumerize :team, in: %i[rsm night purple_magic]

  %i[rsm night purple_magic].each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      where team: team
    }
  end

  store_accessor :options, :custom
  store_accessor :options, :scenario

  def finish_step
    return unless team.night?

    steps.finish_step
  end

  def finished_users
    return [] unless finish_step.present?

    progress_records.where(bot_telegram_scenario_step_id: finish_step.id).uniq(&:bot_telegram_user_id)
  end
end

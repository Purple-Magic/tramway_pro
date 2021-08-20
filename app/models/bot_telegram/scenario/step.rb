# frozen_string_literal: true

class BotTelegram::Scenario::Step < ApplicationRecord
  self.table_name = 'bot_telegram_scenario_steps'

  belongs_to :bot
  has_many :progress_records, class_name: 'BotTelegram::Scenario::ProgressRecord',
                              foreign_key: :bot_telegram_scenario_step_id

  uploader :file, :file, extensions: %i[mp3 wav jpg jpeg png ogg]

  search_by :options

  validates :text, length: { maximum: 1999 }, allow_blank: true

  scope :partner_scope, ->(_user_id) { all }
  scope :finish_step do
    active.where(options: nil).or(active.where(options: '').or(active.where(options: false))).first
  end
  %i[rsm night purple_magic].each do |team|
    scope "#{team}_scope".to_sym, ->(_user_id) { joins(:bot).where('bots.team = ?', team) }
  end

  def continue?
    options.present? || delay.present?
  end
end

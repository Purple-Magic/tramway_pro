# frozen_string_literal: true

class BotTelegram::User < ApplicationRecord
  self.table_name = :bot_telegram_users

  has_many :messages, class_name: 'BotTelegram::Message'
  has_many :progress_records, class_name: 'BotTelegram::Scenario::ProgressRecord', foreign_key: :bot_telegram_user_id
  has_many :steps, class_name: 'BotTelegram::Scenario::Step', through: :progress_records

  search_by :first_name, :username, :last_name

  scope :partner_scope, -> (_user_id) { all }
  scope :rsm_scope, -> (_user_id) do
    joins(progress_records: { step: :bot }).where('bots.team = ?', :rsm)
  end
end

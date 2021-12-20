# frozen_string_literal: true

class Benchkiller::User < ApplicationRecord
  belongs_to :telegram_user, class_name: 'BotTelegram::User', foreign_key: :bot_telegram_user_id
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :companies, through: :companies_users

  default_scope -> { joins(:telegram_user) }

  has_secure_password

  scope :benchkiller_scope, ->(_user) { all }

  validates :bot_telegram_user_id, uniqueness: true

  delegate :username, to: :telegram_user

  def self.from_token_payload(payload)
    find_by uuid: payload['sub']
  end

  def company
    companies.first
  end
end

class Benchkiller::User < ApplicationRecord
  belongs_to :telegram_user, class_name: 'BotTelegram::User', foreign_key: :bot_telegram_user_id
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :companies, through: :companies_users

  has_secure_password

  scope :benchkiller_scope, lambda { |_user| all }

  validates :bot_telegram_user_id, uniqueness: true, if: -> { state == 'active' }

  delegate :username, to: :telegram_user
end

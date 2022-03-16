# frozen_string_literal: true

class Benchkiller::Company < ApplicationRecord
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :users, through: :companies_users, class_name: 'Benchkiller::User'

  store_accessor :data, :portfolio_url
  store_accessor :data, :company_url
  store_accessor :data, :email
  store_accessor :data, :place
  store_accessor :data, :phone
  store_accessor :data, :regions_to_cooperate

  validates :title, uniqueness: true

  scope :benchkiller_scope, ->(_user) { all }
  %i[unviewed approved declined].each do |review_state|
    scope review_state, -> { where review_state: review_state }
  end

  include BotTelegram::BenchkillerBot::AdminFeatures

  after_save do |company|
    send_companies_changes_to_admin_chat company
  end

  search_by :title

  aasm :review_state do
    state :unviewed, initial: true
    state :approved
    state :declined

    event :approve do
      transitions from: :unviewed, to: :approved

      after do
        save!
        user = users.first
        Benchkiller::SendApprovementMessageWorker.perform_async user.id
      end
    end

    event :decline do
      transitions from: :unviewed, to: :declined

      after do
        save!
        user = users.first
        Benchkiller::SendRejectionMessageWorker.perform_async user.id
      end
    end

    event :return_to_unviewed do
      transitions from: %i[approved declined], to: :unviewed
    end
  end

  def user_is?(user)
    users.include? user
  end
end
